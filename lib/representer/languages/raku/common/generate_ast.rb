# docs/common.md and docs/writing-generate-ast.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# the simpler tree that Raku's own parser (Rakudo) gives.
module Representer::Languages::Raku::Common
  class GenerateAST < Representer::Engine::GenerateAST
    # Strip the semicolons, because the tree's statements already show them,
    # and the `use` of each `use` statement, because its node type shows it.
    # use v6; say 1;  ->  (pragma v6) (listop_call say 1)
    strip_tokens ";", "use"

    # Unwrap brackets that only group, and expression statements, because the
    # tree's shape shows both.
    # ($a + $b)  ->  $a + $b
    unwrap :parenthesized_expression, :expression_statement

    # Write each integer as its value.
    # 1_000  ->  1000
    # 0x1F  ->  31
    numbers_are integer: :integer

    SIGILS = { "$" => "scalar", "@" => "array", "%" => "hash", "&" => "code" }.freeze

    DOUBLE_QUOTE_ESCAPES = {
      "\\n" => "\n",
      "\\t" => "\t",
      "\\\"" => "\"",
      "\\\\" => "\\",
      "\\$" => "$",
      "\\@" => "@",
      "\\%" => "%",
      "\\&" => "&",
      "\\{" => "{"
    }.freeze

    def call
      tree.tap do
        write_each_rat_as_its_value!
        write_strings_as_their_values!
        remove_the_indentation_of_each_heredoc!
        give_each_variable_the_type_of_its_sigil!
        mark_each_pragma!
      end
    end

    private
    ### Values ###

    # Write each Rat as its value. A Num, written with an exponent, keeps its
    # text, because Raku reads it as a different type.
    # 1.50  ->  1.5
    # 1e3  ->  1e3
    def write_each_rat_as_its_value!
      each_node(tree) do |node, _|
        next unless node.type == "decimal" && !node.text.match?(/[eE]/)

        value = Representer::Engine::Numbers.decimal(node.text)
        node.text = Representer::Engine::Numbers.write_decimal(value) if value
      end
    end

    # Turn each string into its value, however it is quoted. Keep the
    # structure of a string with interpolation, or with an escape that isn't
    # read here, so it can't make two different strings the same.
    #
    # 'it\'s'  ->  "it's"
    # ‘a’  ->  "a"
    def write_strings_as_their_values!
      transform(tree, "(string) @string") { |match| single_quoted(match.node) }
      transform(tree, "(interpolated_string) @string") { |match| double_quoted(match.node) }
    end

    # Return the value of a string in single quotes, where only `\'` and `\\`
    # are escapes, or of a string in ‘’ without escapes. Return nil for any
    # other string.
    def single_quoted(node)
      text = node.text
      return nil unless text.match?(/\A(?:'.*'|‘.*’)\z/m)

      inner = text[1...-1]
      inner = inner.gsub(/\\(['\\])/, '\1') if text.start_with?("'")
      return nil if text.start_with?("‘") && inner.include?("\\")

      literal(inner)
    end

    # Return the value of a string in double quotes, or nil if it has
    # interpolation or an escape that isn't read here, such as `\x41`.
    def double_quoted(node)
      pieces = node.children.map do |child|
        case child.type
        when "string_content" then child.text
        when "escape_sequence" then DOUBLE_QUOTE_ESCAPES[child.text]
        end
      end
      return nil if pieces.any?(&:nil?) || node.children.empty? && node.text.nil?

      literal(pieces.join)
    end

    # Remove the indentation of each heredoc's lines, up to the indentation
    # of its closing line, as Raku does.
    #
    # e.g. We convert:
    #     q:to/END/;
    #         hello
    #         END
    # internally into:
    #     q:to/END/;
    #     hello
    #     END
    def remove_the_indentation_of_each_heredoc!
      transform(tree, "(heredoc_body) @body") do |match|
        *lines, closing = match.node.text.split("\n", -1)
        indentation = closing.to_s[/\A[ \t]+/]
        next nil if lines.empty? || indentation.nil?

        body = lines.map { |line| line.delete_prefix(indentation) }
        leaf(:heredoc_body, [*body, closing.delete_prefix(indentation)].join("\n"))
      end
    end

    ### Names ###

    # Give each variable the type of its sigil, because a placeholder loses
    # the sigil. Give a public attribute a type of its own, because its name
    # is also the name of the method that callers use, so it keeps its name.
    #
    # @items  ->  (array @items)
    # $.size  ->  (public_attribute $.size)
    def give_each_variable_the_type_of_its_sigil!
      each_node(tree) do |node, _|
        next unless node.type == "variable"

        node.type = node.text.match?(/\A[$@%&]\./) ? "public_attribute" : SIGILS.fetch(node.text[0], "scalar")
      end
    end

    # Mark each `use` of a pragma, which changes how the code runs, so that
    # it stays when the imports go. A module's name starts with a capital
    # letter, and a pragma's doesn't, apart from the MONKEY ones.
    #
    # use v6;  ->  (pragma v6)
    # use lib 'lib';  ->  (pragma lib "lib")
    # use MONKEY-SEE-NO-EVAL;  ->  (pragma MONKEY-SEE-NO-EVAL)
    def mark_each_pragma!
      each_node(tree) do |node, _|
        next unless node.type == "use_statement"

        name = node["module"]
        module_name = name&.type == "identifier" && name.text.match?(/\A[A-Z]/) && !name.text.start_with?("MONKEY")
        node.type = "pragma" unless module_name
      end
    end
  end
end
