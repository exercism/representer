# docs/common.md and docs/writing-generate-ast.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# the simpler tree that Scala's own parser gives.
module Inspector::Languages::Scala::Common
  class GenerateAST < Inspector::Engine::GenerateAST
    # Strip the keywords that sit in a fixed place, because the node types
    # already show them.
    # if (x) y else z  ->  (if_expression x y z)
    strip_tokens "package", "import", "object", "class", "trait", "type", "def", "val", "var", "extends", "derives",
                 "if", "then", "else", "match", "for", "while", "do", "try", "catch", "finally", "throw", "return",
                 "new", "@", "#", "$", "|", "<:", ">:", "<%", "=>>"

    # Keep the `val` or `var` of a parameter, because it makes the parameter a
    # field.
    # class Point(val x: Int)  and  class Point(x: Int)
    keep_tokens "val", "var", in: [:class_parameter, :parameter]

    # Strip these tokens only where they sit in a fixed place, because
    # elsewhere they tell two programs apart.
    # case x => y  ->  (case_clause (bind x) y)
    # trait Box[+T]  ->  (trait_definition Box (type_parameters (covariant_type_parameter T)))
    # class A extends B with C  ->  (class_definition A (extends_clause B C))
    strip_tokens "case", only_in: [:case_clause, :type_case_clause, :enum_case_definitions]
    strip_tokens "+", only_in: :covariant_type_parameter
    strip_tokens "-", only_in: :contravariant_type_parameter
    strip_tokens "with", only_in: :extends_clause
    strip_tokens "enum", only_in: :enum_definition
    strip_tokens "given", only_in: :given_definition
    strip_tokens "extension", only_in: :extension_definition

    # Strip the brackets, commas, semicolons, colons and arrows, because they
    # are layout. A `{` and a `:` that open a body make no difference, and
    # neither do `(` and `{` around the enumerators of a `for`.
    # f(a, b)  ->  (call_expression f (arguments a b))
    # def f(x: Int): Int = x  ->  (function_definition f (parameters (parameter x Int)) Int = x)
    strip_tokens "(", ")", "{", "}", "[", "]", ",", ";", ":", ".", "_", "*", "=>", "<-", "←", "=", '"', '"""'

    # Keep the `=` of a method, because a method written without it returns
    # `Unit`, and keep the `=` of a `for`'s definitions, because a generator
    # has a `<-` in its place.
    # def f() = { x }  and  def f() { x }
    # for (a <- xs; b = a + 1)
    keep_tokens "=", in: [:function_definition, :given_definition, :enumerator]

    # Unwrap brackets that only group, because the tree's shape shows the grouping.
    # (a + b)  ->  a + b
    unwrap :parenthesized_expression

    # Write each number as its value. A `Float` or `Double` keeps its suffix,
    # in lower case.
    #
    # 1_000  ->  1000
    # 0x1F  ->  31
    # 1.50  ->  1.5
    # 1.5e3F  ->  1500.0f
    numbers_are integer: :integer_literal,
                decimal: :floating_point_literal,
                prefixes: { "0x" => 16, "0b" => 2 },
                suffixes: ["f", "d"]

    ESCAPES = {
      '\b' => "\b",
      '\t' => "\t",
      '\n' => "\n",
      '\f' => "\f",
      '\r' => "\r",
      '\"' => '"',
      "\\'" => "'",
      '\\\\' => "\\"
    }.freeze

    PATTERNS = ["tuple_pattern", "case_class_pattern", "infix_pattern", "typed_pattern", "capture_pattern",
                "repeat_pattern", "alternative_pattern"].freeze

    def call
      tree.tap do
        write_long_integers_as_their_values!
        write_strings_as_their_values!
        write_interpolated_strings_as_their_parts!
        mark_the_variables_that_patterns_bind!
        drop_the_backticks_around_names!
        write_indented_blocks_as_blocks!
      end
    end

    private
    ### Values ###

    # Write each `Long` integer as its value too, and keep its `L`.
    # 1_000L  ->  1000L
    # 0x10l  ->  16L
    def write_long_integers_as_their_values!
      prefixes = self.class.numbers[:prefixes]
      each_node(tree) do |node, _|
        next unless node.type == "integer_literal" && node.text.match?(/[lL]\z/)

        value = Inspector::Engine::Numbers.integer(node.text[0...-1], prefixes:)
        node.text = "#{value}L" if value
      end
    end

    # Turn each string into its value, and read its escapes. A string in
    # triple quotes has no escapes, so its text is its value. Keep any other
    # escape as a node of its own, so it can't make two different strings the
    # same.
    #
    # """a"""  ->  "a"
    # "\u0041\n"  ->  "A\n"
    def write_strings_as_their_values!
      transform(tree, "(string) @string") do |match|
        text = match.node.text
        next literal(text[3...-3]) if text.start_with?('"""')

        string_node(text[1...-1].scan(/\\u+\h{4}|\\.|[^\\]+/m).map { |piece| piece.start_with?("\\") ? escape(piece) : piece })
      end
    end

    # Return the text that an escape stands for, or a node for the escape if
    # it stands for no single character.
    def escape(text)
      if text.start_with?("\\u")
        value = text[/\h{4}\z/].to_i(16)
        return value.between?(0xD800, 0xDFFF) ? leaf(:escape_sequence, text) : [value].pack("U")
      end

      ESCAPES.fetch(text) { leaf(:escape_sequence, text) }
    end

    # Build a string's value from its pieces: a literal if it is all text, or a
    # string of literals and escapes. Join neighbouring text.
    def string_node(pieces)
      runs = pieces.chunk_while { |a, b| a.is_a?(String) && b.is_a?(String) }
      parts = runs.map { |run| run.first.is_a?(String) ? literal(run.join) : run.first }
      return literal("") if parts.empty?
      return parts.first if parts.one? && parts.first.type == "literal"

      build(:string, *parts)
    end

    # Write the text of an interpolated string as literals, between its
    # escapes and interpolations, and leave out its quotes. Each interpolator
    # reads the escapes in its own way, so they keep their text. Write `$a`
    # and `${a}` the same way, because the braces only mark where the
    # expression ends.
    #
    # s"a $b!"  ->  (interpolated_string_expression s (interpolated_string "a " (interpolation b) "!"))
    # s"a ${b}!"  ->  (interpolated_string_expression s (interpolated_string "a " (interpolation b) "!"))
    def write_interpolated_strings_as_their_parts!
      each_node(tree) do |node, _|
        next unless node.type == "interpolated_string"

        drop_the_quotes(node)
        node.children = node.children.filter_map do |child|
          case child.type
          when "fragment" then literal(child.text) unless child.text.empty?
          when "interpolation" then interpolation(child)
          else child
          end
        end
      end
    end

    # The grammar puts the quotes of some strings in their first and last
    # pieces of text, so this cuts them off there.
    def drop_the_quotes(string)
      if string.leaf?
        string.children = [leaf(:fragment, string.text)]
        string.text = nil
      end
      first = string.children.first
      if ['"', '"""'].include?(first.type)
        quotes = first.type
      else
        quotes = first.text.start_with?('"""') ? '"""' : '"'
        first.text = first.text.delete_prefix(quotes)
      end
      last = string.children.last
      last.text = last.text[0...-quotes.size] if last.type == "fragment"
    end

    def interpolation(node)
      block = node.named_children.first
      return node unless block.type == "block" && block.named_children.one? && !definition?(block.named_children.first)

      build(:interpolation, block.named_children.first)
    end

    ### Names ###

    # Mark each variable that a pattern binds, as Scala's parser does. In a
    # pattern, a name that starts with a lower-case letter is a new variable,
    # and any other name refers to a value that already exists.
    # case Some(x) =>  ->  (case_clause (case_class_pattern Some (bind x)))
    # case Nil =>  ->  (case_clause Nil)
    def mark_the_variables_that_patterns_bind!
      each_node(tree) do |node, _|
        node.children.map! { |child| pattern_root?(node, child) ? bind_variables(child) : child }
      end
    end

    # Say whether the child of a node is a whole pattern. A `val` that
    # defines one name defines it whatever its case.
    def pattern_root?(node, child)
      case node.type
      when "case_clause" then child.field == "pattern"
      when "val_definition", "var_definition" then child.field == "pattern" && PATTERNS.include?(child.type)
      when "enumerator" then child.named? && child.equal?(node.children.find(&:named?))
      else false
      end
    end

    def bind_variables(pattern)
      return variable?(pattern) ? build(:bind, pattern) : pattern unless PATTERNS.include?(pattern.type)

      pattern.children.map! do |child|
        next child if ["type", "operator", "name"].include?(child.field)

        bind_variables(child)
      end
      pattern
    end

    def variable?(node) = node.type == "identifier" && node.text.match?(/\A[\p{Ll}_]/)

    # Drop the backticks around a name, because Scala reads `` `count` `` and
    # `count` as the same name.
    # `count` + 1  ->  count + 1
    def drop_the_backticks_around_names!
      each_node(tree) do |node, _|
        next unless ["identifier", "type_identifier"].include?(node.type) && node.leaf?

        node.text = node.text[1...-1] if node.text.match?(/\A`.+`\z/)
      end
    end

    ### Blocks ###

    # Write an indented block as a block in braces, and an indented block of
    # one expression as that expression, as Scala's parser does.
    # def f =\n  x  ->  def f = x
    # x match\n  case 1 => y  ->  x match { case 1 => y }
    def write_indented_blocks_as_blocks!
      transform(tree, "(indented_block) @block") do |match|
        statements = match.node.named_children
        next statements.first if statements.one? && !definition?(statements.first)

        match.node.type = "block"
        match.node
      end
      retype(tree, indented_cases: :case_block)
    end

    def definition?(node) = node.type.end_with?("_definition", "_declaration")
  end
end
