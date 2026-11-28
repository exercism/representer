# docs/dsl.md and docs/writing-generate-ast.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# the simpler tree that Swift's own parser (`swiftc -dump-parse`) gives.
module Representer::Languages::Swift::Common
  class GenerateAST < Representer::Engine::GenerateAST
    # Strip the keywords that sit in a fixed place, because the node types
    # already show them.
    # func f() { return 1 }  ->  (function_declaration f (function_body (statements (control_transfer_statement return 1))))
    strip_tokens "func", "init", "deinit", "subscript", "typealias", "associatedtype", "protocol", "import", "willSet",
                 "didSet", "get", "if", "guard", "switch", "for", "in", "while", "repeat", "do", "@"

    # Strip the keywords that sit in a fixed place in these nodes only,
    # because elsewhere they are a choice that changes the code.
    # case red, green  ->  (enum_entry red green)
    # private(set) var x = 1 keeps its `set`
    strip_tokens "case", only_in: [:enum_entry, :switch_entry]
    strip_tokens "self", only_in: :self_expression
    strip_tokens "set", only_in: :setter_specifier
    strip_tokens "is", only_in: :check_expression

    # Strip the brackets, commas and other punctuation, because they are layout.
    # f(a, b)  ->  (call_expression f (call_suffix (value_arguments (value_argument a) (value_argument b))))
    strip_tokens "(", ")", "{", "}", ",", ";", ":", "->", "\"", "\"\"\"", "\\("

    # Strip the punctuation that sits in a fixed place in these nodes only,
    # because elsewhere it changes the code. A `.` before a name in an
    # expression or a pattern means a member of the type that the context
    # needs, a `[` in a call's arguments makes it a subscript, and a `=` in
    # a condition separates a binding from its value.
    # a.b  ->  (navigation_expression a (navigation_suffix b))
    # x == .red keeps its `.`
    # a[0] keeps its `[`
    strip_tokens "[", "]", only_in: [:array_type, :array_literal, :dictionary_type, :dictionary_literal, :capture_list]
    strip_tokens "<", ">", only_in: [:type_arguments, :type_parameters]
    strip_tokens ".", only_in: [:navigation_suffix, :user_type]
    strip_tokens "=", only_in: [:property_declaration, :enum_entry, :typealias_declaration]
    strip_tokens "?", only_in: :ternary_expression

    # Unwrap brackets that only group, because the tree's shape shows the grouping.
    # (a + b) * c  ->  (multiplicative_expression (additive_expression a + b) * c)
    unwrap :tuple_expression

    # Write each number as its value.
    #
    # 1_000  ->  1000
    # 0x1F  ->  31
    # 010  ->  10
    # 1.50  ->  1.5
    numbers_are integer: [:integer_literal, :hex_literal, :oct_literal, :bin_literal],
                decimal: :real_literal

    ESCAPES = {
      '\0' => "\0",
      '\\\\' => "\\",
      '\t' => "\t",
      '\n' => "\n",
      '\r' => "\r",
      '\"' => '"',
      "\\'" => "'"
    }.freeze

    # A name next to one of these binds more tightly than `*`, or is the
    # name of a member.
    TIGHTER_THAN_A_PRODUCT = ["navigation_expression", "navigation_suffix", "call_expression", "postfix_expression",
                              "prefix_expression", "bitwise_operation", "directly_assignable_expression"].freeze

    def call
      tree.tap do
        split_products_written_without_spaces!
        write_strings_as_their_values!
        write_quoted_names_without_backticks!
        give_the_wildcard_a_type_of_its_own!
        write_each_statement_label_as_a_name!
        mark_the_names_that_patterns_bind!
      end
    end

    private
    ### Products ###

    # Split each name that holds a `*` into the product that Swift reads.
    # The grammar lets a name go on with any emoji character, and `*` is one,
    # so it reads `a*b` as one name. Leave a name next to an operator that
    # binds more tightly than `*`, such as `a*b.c`, because its product
    # needs a different shape.
    # a*b + 1  ->  (additive_expression (multiplicative_expression a * b) + 1)
    def split_products_written_without_spaces!
      each_node(tree) do |node, _|
        next if TIGHTER_THAN_A_PRODUCT.include?(node.type)

        node.children.dup.each do |child|
          next unless child.type == "simple_identifier" && child.text.match?(/\A[^*]+(\*[^*]+)+\z/)

          factors = child.text.split("*").map { |text| factor(text) }
          next if factors.any?(nil)

          node.replace_child(child, factors.reduce { |left, right| build(:multiplicative_expression, left, token("*"), right) })
        end
      end
    end

    # Return a factor's name or integer, or nil if it is neither.
    def factor(text)
      return leaf(:simple_identifier, text) if text.match?(/\A[_\p{L}][_\p{L}\p{N}]*\z/)

      value = Representer::Engine::Numbers.integer(text)
      leaf(:integer_literal, value.to_s) if value
    end

    ### Strings ###

    # Turn each string into its value, and read its escapes. Keep each
    # interpolation as a node, and any other escape as a node of its own, so
    # it can't make two different strings the same. A multi-line string
    # loses its first and last line breaks and the indentation of its
    # closing quotes, as Swift reads it. A raw string loses its `#`s.
    #
    # "a\u{41}"  ->  "aA"
    # #"a"#  ->  "a"
    # "a\(b)"  ->  (string_literal "a" (interpolated_expression b))
    # """\n    a\n    """  ->  "a"
    def write_strings_as_their_values!
      transform(tree, "[(line_string_literal) @string (multi_line_string_literal) @string (raw_string_literal) @string]") do |match|
        pieces = pieces_of(match.node)
        string_node(pieces) if pieces
      end
    end

    # Return a string's pieces: its text, the text that each escape stands
    # for, and the node of each interpolation and each other escape. Return
    # nil for a raw string that holds an escape, and for a multi-line raw
    # string, which keep the text they are written with.
    def pieces_of(string)
      pieces = string.named_children.map do |part|
        case part.type
        when "str_escaped_char" then escape(part)
        when "interpolated_expression" then part
        when "raw_str_interpolation" then part["interpolation"]
        else part.leaf? ? part.text : part
        end
      end
      return without_indentation(pieces) if string.type == "multi_line_string_literal"
      return pieces unless string.type == "raw_string_literal"
      return nil if pieces.any? { |piece| piece.is_a?(String) && piece.include?("\\#") } || pieces.first.to_s.match?(/\A#+"""/)

      pieces[0] = pieces[0].sub(/\A#+"/, "")
      pieces[-1] = pieces[-1].sub(/"#+\z/, "")
      pieces
    end

    # Return the text that an escape stands for, or the escape's node if
    # this stage doesn't read it.
    def escape(node)
      if (hex = node.text[/\A\\u\{(\h{1,8})\}\z/, 1])
        value = hex.to_i(16)
        value.between?(0xD800, 0xDFFF) || value > 0x10FFFF ? node : [value].pack("U")
      else
        ESCAPES.fetch(node.text, node)
      end
    end

    # Drop a multi-line string's first line break, its last line break, and
    # the indentation of its closing quotes from the start of each line.
    def without_indentation(pieces)
      last = pieces.last
      return pieces unless last.is_a?(String) && (indent = last[/\n([ \t]*)\z/, 1])

      lines = /\n#{Regexp.escape(indent)}/
      pieces = pieces.map { |text| text.is_a?(String) ? text.gsub(lines, "\n") : text }
      pieces[0] = pieces[0].delete_prefix("\n") if pieces[0].is_a?(String)
      pieces[-1] = pieces[-1].delete_suffix("\n") if pieces[-1].is_a?(String)
      pieces
    end

    # Build a string's value from its pieces: a literal if it is all text, or a
    # string of literals, interpolations and escapes. Join neighbouring text.
    def string_node(pieces)
      runs = pieces.chunk_while { |a, b| a.is_a?(String) && b.is_a?(String) }
      parts = runs.filter_map do |run|
        next run.first unless run.first.is_a?(String)

        text = run.join
        literal(text) unless text.empty?
      end
      return literal("") if parts.empty?
      return parts.first if parts.one? && parts.first.type == "literal"

      build(:string_literal, *parts)
    end

    ### Names ###

    # Write each name in backticks without them, because Swift reads
    # `` `x` `` as the name x.
    # `default`  ->  default
    def write_quoted_names_without_backticks!
      each_node(tree) do |node, _|
        next unless ["simple_identifier", "type_identifier"].include?(node.type) && node.leaf?

        node.text = node.text.delete_prefix("`").delete_suffix("`") if node.text.start_with?("`")
      end
    end

    # Give each `_` a type of its own, because Swift reads it as a keyword
    # that names nothing.
    # func f(_ x: Int)  ->  (parameter (wildcard _) x Int)
    def give_the_wildcard_a_type_of_its_own!
      each_node(tree) { |node, _| node.type = "wildcard" if node.type == "simple_identifier" && node.text == "_" }
    end

    # Write each statement label as a node that holds its name, so that the
    # label and the `break` or `continue` that names it get the same name.
    # outer: while true { break outer }  ->  (statement_label outer) (while_statement ...)
    def write_each_statement_label_as_a_name!
      transform(tree, "(statement_label) @label") do |match|
        build(:statement_label, leaf(:simple_identifier, match.node.text.delete_suffix(":").strip))
      end
    end

    # Mark each name that a pattern binds as a bound_identifier, as the
    # grammar already does for `let x`. A name in a pattern binds if the
    # pattern follows `let` or `var`, or is the variable of a `for` loop
    # without `case`. Swift reads any other name in a pattern as a value to
    # compare with, and a name after a `.` as an enum case.
    # case let (a, b):  ->  a and b are bound
    # case let .some(e):  ->  e is bound, and some isn't
    # case x:  ->  x isn't bound
    def mark_the_names_that_patterns_bind!
      each_node(tree) do |node, _|
        node.children.each_with_index do |child, index|
          next unless child.type == "pattern"

          loop_variable = node.type == "for_statement" && child.children.first&.text != "case"
          mark_bound_names(child, binding: loop_variable || after_let?(node.children[0...index]))
        end
      end
    end

    # Say whether `let` or `var` comes before a pattern among its siblings,
    # since the last `case`.
    def after_let?(siblings)
      siblings.reverse_each do |sibling|
        return true if sibling.type == "value_binding_pattern"
        return false if sibling.text == "case" && !sibling.named?
      end
      false
    end

    # Mark the names in the pattern and the patterns inside it. A pattern
    # binds its names if it holds `let` or `var`, or is inside one that
    # binds.
    def mark_bound_names(pattern, binding:)
      binding ||= pattern.children.any? { |child| child.type == "value_binding_pattern" }
      pattern.children.each_with_index do |child, index|
        if child.type == "pattern"
          mark_bound_names(child, binding:)
        elsif binding && child.type == "simple_identifier" && !child.field && (index.zero? || pattern.children[index - 1].text != ".")
          child.field = "bound_identifier"
        end
      end
    end
  end
end
