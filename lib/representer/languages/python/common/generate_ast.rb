# docs/dsl.md and docs/writing-generate-ast.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# the simpler tree that Python's own parser (the `ast` module) gives.
module Representer::Languages::Python::Common
  class GenerateAST < Representer::Engine::GenerateAST
    # Strip the keywords that sit in a fixed place, because the node types
    # already show them.
    # def f(x): return x  ->  (function_definition f (parameters x) : (block (return_statement x)))
    strip_tokens "class", "def", "lambda", "return", "pass", "break", "continue", "raise", "assert", "del", "try",
                 "finally", "except", "elif", "else", "while", "if", "for", "with", "import", "as", "match", "case",
                 "await", "global", "nonlocal"

    # Strip the brackets, commas and semicolons, because they are layout.
    # f(a, b)  ->  (call f (argument_list a b))
    strip_tokens "(", ")", "[", "]", "{", "}", ",", ";"

    # Keep the commas in subscripts, `match` and `case`, because a trailing
    # comma there makes a tuple.
    # a[1,] keeps its `,`, because it is a[(1,)]
    # case 1,: keeps its `,`, because it matches a tuple of one item
    keep_tokens ",", in: :subscript
    keep_tokens ",", in: :case_clause
    keep_tokens ",", in: :match_statement

    # Unwrap brackets that only group, because the tree's shape shows the grouping.
    # (a + b) * c  ->  (binary_operator (binary_operator a + b) * c)
    unwrap :parenthesized_expression

    # Write each number as its value. An imaginary number keeps its `j`.
    #
    # 1_000  ->  1000
    # 0x1F  ->  31
    # 1e3  ->  1000.0
    # 1.50J  ->  1.5j
    numbers_are integer: :integer,
                decimal: :float,
                suffixes: ["j"]

    ESCAPES = {
      '\n' => "\n",
      '\t' => "\t",
      '\r' => "\r",
      '\a' => "\a",
      '\b' => "\b",
      '\f' => "\f",
      '\v' => "\v",
      '\\\\' => "\\",
      "\\'" => "'",
      '\"' => '"',
      "\\\n" => ""
    }.freeze

    KINDS = { "b" => :bytes, "u" => :u_string, "f" => :joined_string }.freeze

    def call
      tree.tap do
        drop_line_continuations!
        write_imaginary_integers_as_decimals!
        write_strings_as_their_values!
        write_tuples_in_one_shape!
        write_a_lone_generator_argument_without_brackets!
        write_sequence_patterns_in_one_shape!
        mark_the_attributes_that_are_assigned_to!
      end
    end

    private
    # Drop the backslashes that continue a line, because they are layout.
    def drop_line_continuations!
      drop(tree, "(line_continuation)")
    end

    # Write each imaginary number without a point as a decimal, because
    # Python reads both as the same complex number.
    # 2j  ->  2.0j
    def write_imaginary_integers_as_decimals!
      captured(tree, "(integer /[jJ]\\z/) @name").each do |number|
        number.type = "float"
        value = Representer::Engine::Numbers.decimal(number.text.chop)
        number.text = "#{Representer::Engine::Numbers.write_decimal(value)}j"
      end
    end

    ### Strings ###

    # Turn each string into its value, and join the strings written next to
    # each other. Keep the kind of string that Python's parser records: a
    # bytes string, a `u` string and an f-string each get a node of their
    # own, and an f-string keeps its substitutions. Keep any escape not
    # listed in ESCAPES as a node of its own, so it can't make two different
    # strings the same.
    #
    # 'a'  ->  "a"
    # "a" "b"  ->  "ab"
    # r"\n"  ->  "\\n"
    # b"a"  ->  (bytes "a")
    # f"a{b}"  ->  (joined_string "a" (interpolation b))
    def write_strings_as_their_values!
      transform(tree, "(string) @string") { |match| string_value(match.node) }
      transform(tree, "(concatenated_string) @strings") { |match| joined_strings(match.node.children) }
    end

    # Return a string's value, or nil for a template string (`t"..."`), which
    # makes an object of its own.
    def string_value(string)
      prefix = string.children.first.text.downcase.delete("\"'")
      return nil if prefix.include?("t")

      pieces = string.children[1...-1].flat_map do |part|
        part.type == "string_content" ? content_pieces(part, raw: prefix.include?("r")) : [part]
      end
      string_node(pieces, KINDS.fetch(prefix.delete("r"), :string))
    end

    # Return the text of a string's content, with its escapes read. A raw
    # string reads no escapes.
    def content_pieces(content, raw:)
      return [content.text] if content.leaf?

      content.children.map do |piece|
        case piece.type
        when "escape_sequence" then raw ? piece.text : ESCAPES.fetch(piece.text, piece)
        when "escape_interpolation" then piece.text[0]
        else piece.text
        end
      end
    end

    # Join the values of strings written next to each other. The result is an
    # f-string if any of them is one, and otherwise the kind of the first.
    def joined_strings(values)
      types = values.map(&:type)
      type = types.include?("joined_string") ? "joined_string" : types.first.sub("literal", "string")
      pieces = values.flat_map { |value| value.type == "literal" ? [value] : value.children }
      string_node(pieces.map { |piece| piece.type == "literal" ? piece.text : piece }, type.to_sym)
    end

    # Build a string's value from its pieces, and join neighbouring text. A
    # plain string that is all text is a literal.
    def string_node(pieces, type)
      runs = pieces.chunk_while { |a, b| a.is_a?(String) && b.is_a?(String) }
      parts = runs.map { |run| run.first.is_a?(String) ? literal(run.join) : run.first }
      return parts.first || literal("") if type == :string && parts.all? { |part| part.type == "literal" }

      build(type, *parts)
    end

    ### Tuples and patterns ###

    # Write a tuple without brackets as a tuple, as Python's parser does.
    # return a, b  ->  return (a, b)
    # a, b = x  ->  (a, b) = x
    def write_tuples_in_one_shape!
      retype(tree, expression_list: :tuple, pattern_list: :tuple_pattern)
    end

    # Drop the brackets around a generator that is a call's only argument,
    # because Python's parser reads both as one call.
    # sum((x for x in xs))  ->  sum(x for x in xs)
    def write_a_lone_generator_argument_without_brackets!
      find_all(tree, "(call arguments: (argument_list (generator_expression) @generator) @arguments)").each do |match|
        match.node.replace_child(match[:arguments], match[:generator]) if match[:arguments].named_children.one?
      end
    end

    # Write each list pattern in a `case` as a tuple pattern, because Python's
    # parser reads both as one sequence pattern.
    # case [a, b]:  ->  case (a, b):
    def write_sequence_patterns_in_one_shape!
      captured(tree, "(case_clause) @name").each do |clause|
        clause.each_descendant { |node| node.type = "tuple_pattern" if node.type == "list_pattern" }
      end
    end

    ### Names ###

    # Put the name of each assigned attribute in the field `name`, as Python's
    # parser marks it with its Store context, so that representation/spec.rb can
    # list it.
    # self.«count» = 0
    # self.«a», self.«b» = pair
    def mark_the_attributes_that_are_assigned_to!
      targets = "[(assignment left: (_) @name) (augmented_assignment left: (_) @name) (for_statement left: (_) @name) " \
                "(for_in_clause left: (_) @name) (as_pattern_target (_) @name)]"
      captured(tree, targets).each { |target| mark_assigned_attributes(target) }
    end

    def mark_assigned_attributes(target)
      case target.type
      when "attribute" then target[:attribute].field = "name"
      when "tuple_pattern", "list_pattern", "list_splat_pattern"
        target.named_children.each { |child| mark_assigned_attributes(child) }
      end
    end
  end
end
