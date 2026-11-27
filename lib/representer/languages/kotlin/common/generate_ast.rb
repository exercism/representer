# REPRESENTER_DSL.md and WRITING_GENERATE_AST.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# the simpler tree that Kotlin's own parser gives.
module Representer::Languages::Kotlin::Common
  class GenerateAST < Representer::Engine::GenerateAST
    # Strip the keywords that sit in a fixed place, because the node types
    # already show them.
    # if (x) y else z  ->  (if_expression x y z)
    strip_tokens "package", "import", "typealias", "fun", "object", "companion", "init", "by", "where", "if", "else",
                 "when", "for", "while", "do", "try", "catch", "finally"

    # Keep the `fun` of a `fun interface`, because an interface without it is
    # a different kind of interface.
    # fun interface Shape  and  interface Shape
    keep_tokens "fun", in: :class_declaration

    # Strip these keywords only where they sit in a fixed place, because
    # elsewhere they tell two programs apart.
    # for (x in xs)  ->  (for_statement x xs)
    # constructor(a: Int) : this(a)  ->  (secondary_constructor (function_value_parameters (parameter a Int)) ...)
    strip_tokens "in", only_in: [:for_statement, :range_test]
    strip_tokens "is", only_in: :type_test
    strip_tokens "constructor", only_in: :secondary_constructor
    strip_tokens "get", only_in: :getter
    strip_tokens "set", only_in: :setter

    # Strip the brackets, commas and semicolons, because they are layout. A
    # trailing comma and a `;` between statements make no difference.
    # f(a, b,)  ->  (call_expression f (call_suffix (value_arguments a b)))
    strip_tokens "(", ")", "{", "}", "[", "]", ",", ";"

    # Keep the brackets of a destructuring declaration, because `(a, b)` and
    # `[a, b]` destructure in different ways.
    # val (a, b) = pair  and  val [a, b] = pair
    keep_tokens "(", ")", "[", "]", in: :multi_variable_declaration

    # Strip the angle brackets around type arguments and type parameters, and
    # the arrows that sit in a fixed place.
    # List<Int>  ->  (user_type List (type_arguments Int))
    # 1 -> "a"  ->  (when_entry 1 "a")
    strip_tokens "<", ">", only_in: [:type_arguments, :type_parameters]
    strip_tokens "->", only_in: [:function_type, :when_entry]

    # Unwrap brackets that only group, because the tree's shape shows the grouping.
    # (a + b)  ->  a + b
    unwrap :parenthesized_expression, :parenthesized_type, :parenthesized_user_type

    # Write each number as its value. A `Float` keeps its `f`, in lower case.
    #
    # 1_000  ->  1000
    # 0x1F  ->  31
    # 0b101  ->  5
    # 1.50  ->  1.5
    # 1e3  ->  1000.0
    # 1.5F  ->  1.5f
    numbers_are integer: [:integer_literal, :hex_literal, :bin_literal],
                decimal: :real_literal,
                prefixes: { "0x" => 16, "0b" => 2 },
                suffixes: ["f"]

    ESCAPES = {
      '\t' => "\t",
      '\b' => "\b",
      '\n' => "\n",
      '\r' => "\r",
      "\\'" => "'",
      '\"' => '"',
      '\\\\' => "\\",
      '\$' => "$"
    }.freeze

    def call
      tree.tap do
        write_soft_keywords_used_as_names_as_names!
        drop_the_backticks_around_names!
        give_the_unused_name_its_own_type!
        write_long_and_unsigned_integers_as_their_values!
        write_characters_as_their_values!
        write_strings_as_their_values!
        wrap_each_label_and_its_expression_together!
        put_each_import_straight_into_the_file!
      end
    end

    private
    ### Names ###

    # Write a name that is also a soft keyword as a name, such as a parameter
    # called `value`.
    # set(value)  ->  (setter (parameter_with_optional_type value))
    def write_soft_keywords_used_as_names_as_names!
      each_node(tree) do |node, _|
        next unless ["simple_identifier", "type_identifier"].include?(node.type) && !node.leaf?

        node.text = text_of(node)
        node.children = []
      end
    end

    # Drop the backticks around a name, because Kotlin reads `` `count` `` and
    # `count` as the same name.
    # `count` + 1  ->  count + 1
    def drop_the_backticks_around_names!
      each_node(tree) do |node, _|
        next unless ["simple_identifier", "type_identifier", "label"].include?(node.type) && node.leaf?

        node.text = node.text[1...-1] if node.text.match?(/\A`.+`\z/)
      end
    end

    # Give `_` a type of its own, because it defines no name.
    # val (_, b) = pair  ->  (multi_variable_declaration (variable_declaration (unused_name _)) ...)
    def give_the_unused_name_its_own_type!
      each_node(tree) { |node, _| node.type = "unused_name" if node.type == "simple_identifier" && node.text == "_" }
    end

    ### Values ###

    # Write each `Long` and unsigned integer as its value too, and keep its
    # suffix, in one case.
    # 1_000L  ->  1000L
    # 0x10L  ->  16L
    # 1U  ->  1u
    # 1UL  ->  1uL
    def write_long_and_unsigned_integers_as_their_values!
      prefixes = self.class.numbers[:prefixes]
      each_node(tree) do |node, _|
        next unless ["long_literal", "unsigned_literal"].include?(node.type) && node.leaf?

        digits, suffix = node.text.match(/\A(.*?)([uU]?[lL]?)\z/).captures
        value = Representer::Engine::Numbers.integer(digits, prefixes:)
        node.text = "#{value}#{suffix.downcase.sub('l', 'L')}" if value
      end
    end

    # Turn each character into its value, and read its escapes. A character
    # keeps a node of its own, so `'a'` and `"a"` stay apart.
    # '\u0041'  ->  (character_literal "A")
    def write_characters_as_their_values!
      transform(tree, "(character_literal) @character") do |match|
        pieces = escaped_pieces(match.node.text[1...-1])
        build(:character_literal, *pieces.map { |piece| piece.is_a?(String) ? literal(piece) : piece })
      end
    end

    # Turn each string into its value, and read its escapes. A raw string
    # (`"""a"""`) has no escapes, so its text is its value. Write `$a` and
    # `${a}` the same way, because both put the value of `a` into the string.
    # Keep any escape that stands for no single character, such as half of a
    # surrogate pair, as a node of its own.
    #
    # """a"""  ->  "a"
    # "\u0041\$"  ->  "A$"
    # "a$b"  ->  (string_literal "a" (interpolation b))
    # "a${b}"  ->  (string_literal "a" (interpolation b))
    def write_strings_as_their_values!
      transform(tree, "(string_literal) @string") do |match|
        next literal("") if match.node.leaf?

        raw = match.node.children.first.text.end_with?('"""')
        string_node(match.node.children.flat_map { |part| string_pieces(part, raw) } + closing_quotes(match.node, raw))
      end
    end

    # Return the quotes at the end of a raw string's text, which the grammar
    # puts in its closing `"""`.
    # """say "hi""""  ->  "say \"hi\""
    def closing_quotes(string, raw)
      closing = string.children.last
      raw && closing.type == "fragment" && closing.text.size > 3 ? [closing.text[3..]] : []
    end

    def string_pieces(part, raw)
      case part.type
      when "fragment", "interpolation_expression_start", "interpolation_identifier_start",
           "interpolation_expression_end" then []
      when "string_content" then raw ? [part.text] : escaped_pieces(part.text)
      when "interpolated_identifier" then [build(:interpolation, leaf(:simple_identifier, text_of(part)))]
      when "interpolated_expression" then [build(:interpolation, *part.children)]
      else [part]
      end
    end

    # Split text into its characters and escapes, and read each escape.
    def escaped_pieces(text)
      text.scan(/\\u\h{4}|\\.|[^\\]+/m).map { |piece| piece.start_with?("\\") ? escape(piece) : piece }
    end

    # Return the text that an escape stands for, or a node for the escape if
    # it stands for no single character.
    def escape(text)
      if text.start_with?("\\u")
        value = text[2..].to_i(16)
        return value.between?(0xD800, 0xDFFF) ? leaf(:escape, text) : [value].pack("U")
      end

      ESCAPES.fetch(text) { leaf(:escape, text) }
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

    ### Imports and labels ###

    # Put each import straight into the file, so that dropping the imports
    # leaves nothing behind.
    # import a.b  ->  (source_file (import_header a.b))
    def put_each_import_straight_into_the_file!
      tree.children = tree.children.flat_map { |child| child.type == "import_list" ? child.children : [child] }
    end

    # Wrap each label and the expression after it in one node, as Kotlin's
    # parser does, and drop the `@` from every label.
    # outer@ for (x in xs) break@outer  ->  (labeled_expression outer (for_statement ... (jump_expression break@ outer)))
    def wrap_each_label_and_its_expression_together!
      each_node(tree) do |node, _|
        node.children.each { |child| child.text = child.text.delete_suffix("@") if child.type == "label" }
        next if ["jump_expression", "this_expression", "super_expression", "labeled_expression"].include?(node.type)

        node.children = wrap_labels(node.children)
      end
    end

    # Wrap each label with the child after it, working from the end, so that
    # `a@ b@ x` becomes a label around a label.
    def wrap_labels(children)
      children.reverse.each_with_object([]) do |child, wrapped|
        if child.type == "label" && wrapped.any?
          wrapped.unshift(build(:labeled_expression, { label: child }, wrapped.shift))
        else
          wrapped.unshift(child)
        end
      end
    end
  end
end
