# docs/common.md and docs/writing-generate-ast.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# a simpler tree, with one form for each spelling that Euphoria's parser reads
# the same way.
module Inspector::Languages::Euphoria::Common
  class GenerateAST < Inspector::Engine::GenerateAST
    # Strip the keywords that sit in a fixed place, because the node types
    # already show them.
    # if x then return y end if  ->  (if_statement x (block (return_statement y)))
    strip_tokens "function", "procedure", "type", "end", "if", "then", "elsif", "else", "for", "to", "while",
                 "do", "loop", "until", "switch", "case", "return", "exit", "continue", "retry", "break", "goto",
                 "include", "as", "namespace", "constant", "enum", "?"

    # Strip `by` from a for loop, where the field `step` shows it, and the
    # keyword of a label or entry statement. Keep them elsewhere, as in
    # `enum by 2` and `while x with entry label "outer" do`.
    strip_tokens "by", only_in: :for_statement
    strip_tokens "label", only_in: :label_statement
    strip_tokens "entry", only_in: :entry_statement

    # Keep `else` in `case else`, and the tokens of `ifdef`, whose parts have
    # no fields to tell them apart.
    keep_tokens "else", in: :case_clause
    keep_tokens "then", "end", in: :ifdef_statement

    # Strip the `=` that sits in a fixed place in a declaration, a default or
    # a loop. Keep it in an assignment and a comparison, where it is one
    # operator of several.
    # integer x = 1  ->  (variable_declaration integer (variable_declarator x 1))
    strip_tokens "=", only_in: [:variable_declarator, :constant_declarator, :enum_member, :parameter,
                                :for_statement, :multiple_assignment]

    # Strip the brackets, commas, `:` and `$`, because they are layout or the
    # node types show them. Euphoria's parser reads a `$` at the end of a
    # list of constants or enum members as the end of the list.
    # {1, 2,}  ->  (sequence 1 2)
    # s[2..$]  ->  (slice_expression s (slice 2 (dollar)))
    # constant A = 1, $  ->  (constant_declaration (constant_declarator A 1))
    strip_tokens "(", ")", "{", "}", "[", "]", ",", "..", ":", "$"

    # Unwrap brackets that only group, because the tree's shape shows the
    # grouping.
    # (a + b) * c  ->  (binary_expression (binary_expression a + b) * c)
    unwrap :parenthesized_expression

    # Write each number as its value. Euphoria reads `#` and `0x` as hex,
    # `0t` and `0o` as octal, `0b` as binary and `0d` as decimal. `1.0` and
    # `1` stay apart, because they are written as different kinds of number.
    #
    # #1F  ->  31
    # 1_000  ->  1000
    # .50  ->  0.5
    numbers_are integer: :integer,
                decimal: :float,
                prefixes: { "#" => 16, "0x" => 16, "0t" => 8, "0o" => 8, "0b" => 2, "0d" => 10 }

    ESCAPES = {
      '\n' => "\n",
      '\t' => "\t",
      '\r' => "\r",
      '\0' => "\0",
      '\\\\' => "\\",
      '\"' => '"',
      "\\'" => "'"
    }.freeze

    def call
      tree.tap do
        mark_each_omitted_argument!
        write_include_paths_without_quotes!
        write_strings_as_their_values!
        write_raw_strings_as_their_values!
        write_characters_as_their_values!
      end
    end

    private
    # Mark each argument left out of a call, so that stripping the commas
    # can't make `f(a,,b)` the same as `f(a,b)`. Euphoria gives a left-out
    # argument its default.
    # f(a,,b)  ->  (call f (argument_list a (omitted_argument) b))
    def mark_each_omitted_argument!
      captured(tree, "(argument_list) @name").each do |arguments|
        tokens = arguments.children
        arguments.children = tokens.each_with_index.flat_map do |child, index|
          previous = tokens[index - 1] if index.positive?
          omitted = previous && !previous.named? && !child.named? && [previous.text, child.text] != ["(", ")"]
          omitted ? [build(:omitted_argument), child] : [child]
        end
      end
    end

    # Write each include's path without quotes, because Euphoria reads
    # `include "std/math.e"` and `include std/math.e` the same way.
    # include "std/math.e"  ->  (include_statement std/math.e)
    def write_include_paths_without_quotes!
      transform(tree, "(include_statement path: (string) @path) @include") do |match|
        text = match[:path].named_children.map(&:text).join
        match.node.tap { |include| include.replace_child(match[:path], leaf(:include_path, text, field: :path)) }
      end
    end

    ### Strings ###

    # Turn each string into its value, and read its escapes. Keep any other
    # escape as a node of its own, so it can't make two different strings
    # the same.
    #
    # "a\tb"  ->  "a\tb"
    # "a\x41"  ->  (string "a" (escape_sequence \x41))
    def write_strings_as_their_values!
      transform(tree, "(string) @string") do |match|
        pieces = match.node.named_children.map do |piece|
          piece.type == "escape_sequence" ? ESCAPES.fetch(piece.text, piece) : piece.text
        end
        string_node(pieces)
      end
    end

    # Turn each raw string on one line into its value, so that `` `a\d` ``
    # and `"a\\d"` are the same. Keep a raw string with a line break as a raw
    # string, because Euphoria can trim the margin of its lines.
    #
    # `a\d`  ->  "a\\d"
    # """ab"""  ->  "ab"
    def write_raw_strings_as_their_values!
      transform(tree, "(raw_string) @string") do |match|
        quote = match.node.text.start_with?('"""') ? 3 : 1
        value = match.node.text[quote...-quote]
        value.include?("\n") ? build(:raw_string, literal(value)) : literal(value)
      end
    end

    # Write each character as its value, and read its escape.
    # '\''  ->  (character "'")
    def write_characters_as_their_values!
      transform(tree, "(character) @character") do |match|
        piece = match.node.named_children.first
        value = piece.type == "escape_sequence" ? ESCAPES.fetch(piece.text, piece) : piece.text
        build(:character, value.is_a?(String) ? literal(value) : value)
      end
    end

    # Build a string's value from its pieces: a literal if it is all text, or
    # a string of literals and escapes. Join neighbouring text.
    def string_node(pieces)
      runs = pieces.chunk_while { |a, b| a.is_a?(String) && b.is_a?(String) }
      parts = runs.map { |run| run.first.is_a?(String) ? literal(run.join) : run.first }
      return literal("") if parts.empty?
      return parts.first if parts.one? && parts.first.type == "literal"

      build(:string, *parts)
    end
  end
end
