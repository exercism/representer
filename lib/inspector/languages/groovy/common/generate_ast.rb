# docs/common.md and docs/writing-generate-ast.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# the simpler tree that Groovy's own parser gives.
module Inspector::Languages::Groovy::Common
  class GenerateAST < Inspector::Engine::GenerateAST
    # Strip the keywords that sit in a fixed place, because the node types
    # already show them.
    # if (x) { return y }  ->  (if_statement x (block (return_statement y)))
    strip_tokens "package", "import", "class", "interface", "enum", "trait", "record", "if", "else", "for", "while",
                 "do", "switch", "try", "catch", "finally", "return", "throw", "throws", "break", "continue", "assert",
                 "implements", "permits"

    # Strip `def` and `var`, because Groovy's parser reads each of them as a
    # declaration with no type.
    # def x = 1  ->  (local_variable_declaration (variable_declarator x 1))
    # final def x = 1  ->  (local_variable_declaration final (variable_declarator x 1))
    strip_tokens "def", "var"

    # Strip these keywords only where they sit in a fixed place, because
    # elsewhere they tell two programs apart.
    # new A()  ->  (object_creation_expression A (argument_list))
    # class A extends B  ->  (class_declaration A (superclass B) ...)
    strip_tokens "new", only_in: [:object_creation_expression, :array_creation_expression]
    strip_tokens "extends", only_in: [:superclass, :extends_interfaces]
    strip_tokens "case", only_in: [:switch_case, :switch_arrow_case]
    strip_tokens "default", only_in: :switch_default
    strip_tokens "as", only_in: :cast_expression
    strip_tokens "synchronized", only_in: :synchronized_statement
    strip_tokens "yield", only_in: :yield_statement

    # Strip `in` and `:` from a `for` loop over a collection, because Groovy's
    # parser reads `for (x in xs)` and `for (x : xs)` as the same loop.
    # for (x in xs)  ->  (for_in_statement x xs)
    strip_tokens "in", ":", only_in: :for_in_statement

    # Strip the brackets, commas, dots and semicolons, because they are
    # layout. A trailing comma and a `;` between statements make no
    # difference.
    # f(a, b,);  ->  (method_invocation f (argument_list a b))
    # a.b  ->  (field_access a b)
    strip_tokens "(", ")", "{", "}", "[", "]", ",", ";", "."

    # Keep the brackets in a type's dimensions and the `;` in a `for` loop's
    # header, because they are the only thing that tells two programs apart
    # there.
    # int[] and int[][]
    # for (;; i++) and for (i++;;)
    keep_tokens "[", "]", in: :dimensions
    keep_tokens ";", in: :for_statement

    # Strip the punctuation that sits in a fixed place in these nodes.
    # [a: 1]  ->  (map_literal (map_entry "a" 1))
    # a ? b : c  ->  (ternary_expression a ? b c)
    # assert a, "m"  ->  (assert_statement a "m")
    # { x -> x }  ->  (closure (closure_parameters (closure_parameter x)) ...)
    # List<Integer>  ->  (generic_type List (type_arguments Integer))
    strip_tokens ":", only_in: [:map_literal, :map_entry, :named_argument, :ternary_expression, :labeled_statement,
                                :assert_statement, :switch_case]
    strip_tokens "->", only_in: [:closure_parameters, :lambda_expression, :switch_arrow_case]
    strip_tokens "<", ">", only_in: [:type_arguments, :type_parameters, :method_type_parameters]
    strip_tokens "=", only_in: [:variable_declarator, :formal_parameter, :closure_parameter, :multi_assignment_declaration,
                                :multi_assignment_expression, :resource]
    strip_tokens "@", only_in: :annotation
    strip_tokens "|", only_in: :multi_type

    # Unwrap brackets that only group, because the tree's shape shows the grouping.
    # (a + b)  ->  a + b
    unwrap :parenthesized_expression

    # Write each number as its value. A leading 0 means octal. A `Float` or
    # `Double` keeps its suffix, in lower case.
    #
    # 1_000  ->  1000
    # 0x1F  ->  31
    # 017  ->  15
    # 1.50  ->  1.5
    # 1e3  ->  1000.0
    # 1.5F  ->  1.5f
    numbers_are integer: :number_literal,
                decimal: :number_literal,
                prefixes: { "0x" => 16, "0b" => 2, "0" => 8 },
                suffixes: ["f", "d"]

    ESCAPES = {
      '\b' => "\b",
      '\t' => "\t",
      '\n' => "\n",
      '\f' => "\f",
      '\r' => "\r",
      '\s' => " ",
      '\"' => '"',
      "\\'" => "'",
      '\\\\' => "\\",
      '\$' => "$"
    }.freeze

    def call
      tree.tap do
        write_integers_with_a_suffix_as_their_values!
        write_strings_as_their_values!
        write_map_keys_that_are_names_as_strings!
        write_each_variable_of_a_typed_declaration_as_a_declarator!
        write_methods_with_no_return_type_as_methods!
        write_command_chains_as_method_calls!
        pass_a_closure_after_the_brackets_as_the_last_argument!
      end
    end

    private
    ### Values ###

    # Write each integer with a suffix as its value too, and keep its suffix,
    # in upper case. A `BigDecimal` is what Groovy gives a decimal without a
    # suffix, so a decimal drops its `G`.
    #
    # 1_000L  ->  1000L
    # 0x10l  ->  16L
    # 2g  ->  2G
    # 1.50G  ->  1.5
    def write_integers_with_a_suffix_as_their_values!
      prefixes = self.class.numbers[:prefixes]
      each_node(tree) do |node, _|
        next unless node.type == "number_literal" && node.leaf?

        digits, suffix = node.text.match(/\A(.*?)([lLiIgG]?)\z/).captures
        next if suffix.empty?

        if (value = Inspector::Engine::Numbers.integer(digits, prefixes:))
          node.text = "#{value}#{suffix.upcase}"
        elsif suffix.upcase == "G" && (value = Inspector::Engine::Numbers.decimal(digits))
          node.text = Inspector::Engine::Numbers.write_decimal(value)
        end
      end
    end

    # Turn each string into its value, and read its escapes, so `'a'`, `"a"`,
    # `'''a'''`, `"""a"""` and `/a/` are the same. A slashy string (`/a/` or
    # `$/a/$`) reads only the escapes of its own delimiters. Write `$a` and
    # `${a}` the same way, because both put the value of `a` into the string.
    # Keep any other escape as a node of its own.
    #
    # 'a\u0041'  ->  "aA"
    # /a\/b/  ->  "a/b"
    # "a$b.c"  ->  (string_literal "a" (interpolation (field_access b c)))
    # "a${b.c}"  ->  (string_literal "a" (interpolation (field_access b c)))
    def write_strings_as_their_values!
      transform(tree, "(string_literal) @string") do |match|
        string = match.node
        next string_node(escaped_pieces(string.text.delete_prefix("'''").delete_suffix("'''"))) if string.text&.start_with?("'''")
        next string_node(escaped_pieces(string.text[1...-1])) if string.leaf?

        kind = string_kind(string)
        string_node(string.children.flat_map { |part| string_pieces(part, kind) })
      end
    end

    # A slashy string has no opening token in the tree, only its closing `/`.
    def string_kind(string)
      tokens = string.children.reject(&:named?).map(&:type)
      return :dollar_slashy if tokens.include?("$/")
      return :slashy if tokens == ["/"]

      :double
    end

    def string_pieces(part, kind)
      case part.type
      when "string_fragment" then fragment_pieces(part.text, kind)
      when "gstring_dollar_interpolation" then [build(:interpolation, dotted_names(part.named_children.first.text[1..]))]
      when "gstring_brace_interpolation" then [build(:interpolation, *part.named_children)]
      when "\"", '"""', "/", "$/", "/$" then []
      else [part]
      end
    end

    def fragment_pieces(text, kind)
      case kind
      when :slashy then [text.gsub("\\/", "/")]
      when :dollar_slashy then [text.gsub("$$", "$").gsub("$/", "/")]
      else escaped_pieces(text)
      end
    end

    # Write `$a.b.c` in a string as the field accesses it stands for.
    # "$a.b"  ->  (interpolation (field_access a b))
    def dotted_names(text)
      first, *rest = text.split(".")
      rest.reduce(leaf(:identifier, first)) do |object, field|
        build(:field_access, { object: }, { field: leaf(:identifier, field) })
      end
    end

    # Split text into its characters and escapes, and read each escape.
    def escaped_pieces(text)
      text.scan(/\\u+\h{4}|\\[0-3]?[0-7]{1,2}|\\.|[^\\]+/m).map { |piece| piece.start_with?("\\") ? escape(piece) : piece }
    end

    # Return the text that an escape stands for, or a node for the escape if
    # it stands for no single character, such as half of a surrogate pair.
    def escape(text)
      case text
      when /\A\\u+(\h{4})\z/
        value = Regexp.last_match(1).to_i(16)
        value.between?(0xD800, 0xDFFF) ? leaf(:escape, text) : [value].pack("U")
      when /\A\\([0-3]?[0-7]{1,2})\z/ then Regexp.last_match(1).to_i(8).chr(Encoding::UTF_8)
      else ESCAPES.fetch(text) { leaf(:escape, text) }
      end
    end

    # Build a string's value from its pieces: a literal if it is all text, or a
    # string of literals, escapes and interpolations. Join neighbouring text.
    def string_node(pieces)
      runs = pieces.chunk_while { |a, b| a.is_a?(String) && b.is_a?(String) }
      parts = runs.map { |run| run.first.is_a?(String) ? literal(run.join) : run.first }
      return literal("") if parts.empty?
      return parts.first if parts.one? && parts.first.type == "literal"

      build(:string_literal, *parts)
    end

    # Write a map key or named argument that is a bare name as a string,
    # because Groovy's parser reads `[a: 1]` as `['a': 1]`. A key in brackets
    # stays a name, because Groovy reads its value.
    # [a: 1]  ->  (map_literal (map_entry "a" 1))
    # f(a: 1)  ->  (method_invocation f (argument_list (named_argument "a" 1)))
    def write_map_keys_that_are_names_as_strings!
      transform(tree, "[(map_entry key: (identifier) @key) (named_argument key: (identifier) @key)] @entry") do |match|
        match.node.replace_child(match[:key], literal(match[:key].text))
        match.node
      end
    end

    ### Declarations and calls ###

    # Wrap each name and value of a typed declaration in a declarator, as an
    # untyped declaration has, so `int a, b = 1` and `int a = b, c` stay
    # apart.
    # int a = 1, b  ->  (local_variable_declaration int (variable_declarator a 1) (variable_declarator b))
    def write_each_variable_of_a_typed_declaration_as_a_declarator!
      each_node(tree) do |node, _|
        next unless node.type == "local_variable_declaration" && node[:name]

        node.children = node.children.slice_before { |child| child.field == "name" }.flat_map do |run|
          run.first.field == "name" ? declarator(run) : run
        end
      end
    end

    # A declarator holds the name and its value, and leaves the `,` before the
    # next name outside.
    def declarator(run)
      rest = run.drop_while { |child| child.field != "value" }.drop(1)
      [build(:variable_declarator, *(run - rest)), *rest]
    end

    # Write each method with no return type as a method. The grammar reads
    # it as a constructor, but Groovy's parser only reads a constructor if it
    # has the name of its class.
    # class A { static f() { 1 } }  ->  (class_declaration A (class_body (method_declaration static f ...)))
    def write_methods_with_no_return_type_as_methods!
      each_node(tree) do |node, _|
        next unless ["class_declaration", "enum_declaration", "trait_declaration", "record_declaration"].include?(node.type)

        node[:body].children.each do |member|
          member.type = "method_declaration" if member.type == "constructor_declaration" && member[:name].text != node[:name].text
        end
      end
    end

    # Write a call without brackets as a call with them, because Groovy's
    # parser reads the two the same way.
    # println "x"  ->  println("x")
    # a.b c, d  ->  a.b(c, d)
    def write_command_chains_as_method_calls!
      transform(tree, "(command_chain receiver: (_) @receiver) @chain") do |match|
        arguments = match.node.children.select { |child| child.field == "argument" }
        next nil unless match.node.named_children.size == arguments.size + 1

        call = build(:method_invocation, { function: match[:receiver] }, { arguments: build(:argument_list, *arguments) })
        build(:expression_statement, call)
      end
    end

    # Pass a closure written after a call's brackets as its last argument,
    # because Groovy's parser reads the two the same way.
    # f(a) { it }  ->  f(a, { it })
    # f { it }  ->  f({ it })
    def pass_a_closure_after_the_brackets_as_the_last_argument!
      transform(tree, "(method_invocation closure: (closure) @closure) @call") do |match|
        call = match.node
        arguments = call[:arguments] || build(:argument_list).tap { |list| list.field = "arguments" }
        call.children.delete(match[:closure])
        call.children << arguments unless call[:arguments]
        match[:closure].field = nil
        arguments.children << match[:closure]
        call
      end
    end
  end
end
