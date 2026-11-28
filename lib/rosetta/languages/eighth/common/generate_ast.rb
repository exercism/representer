# docs/common.md and docs/writing-generate-ast.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# a simpler tree. 8th code is mostly a flat list of words, and the grammar
# only gives structure to definitions, conditionals, loops, quotations and
# JSON literals.
module Rosetta::Languages::Eighth::Common
  class GenerateAST < Rosetta::Engine::GenerateAST
    # Strip the tokens that sit in a fixed place, because the node types
    # already show them. `;:` ends one definition and starts the next, so
    # `; :` and `;:` are the same.
    # : f 1 ;: g 2 ;  ->  (word_definition f 1) (word_definition g 2)
    # ( 1 + )  ->  (quotation (block 1 +))
    # [1, 2]  ->  (array 1 2)
    strip_tokens ":", ";", ";:", "(", ")", "[", "]", "{", "}", ",", "'",
                 "repeat", "constant", "var", "needs", "true", "false", "null"

    # Strip `if` and `then`, and keep the other words that open and close a
    # conditional, because `!if` tests the opposite, `;then` also leaves the
    # word, and `else` shows which branch is which.
    # if 1 else 2 then  ->  (if_statement (block 1) else (block 2))
    strip_tokens "if", "then", only_in: :if_statement

    # Write each number as its value. `$` and `0x` start a hexadecimal
    # number, and 8th has no digit separators.
    # 0xff  ->  255
    # 1.50  ->  1.5
    numbers_are integer: :number,
                decimal: :number,
                prefixes: { "0x" => 16, "$" => 16 },
                separators: []

    ESCAPES = { "n" => "\n", "r" => "\r", "t" => "\t", "\\" => "\\", "\"" => "\"" }.freeze

    def call
      tree.tap do
        write_strings_as_their_values!
        write_bare_keys_as_strings!
      end
    end

    private
    # Write each string as its value. An escape that isn't read here stays
    # as a node of its own, so two different strings can't get the same
    # value.
    # "a\nb"  ->  a string with a line break
    def write_strings_as_their_values!
      transform(tree, "(string) @string") do |match|
        pieces = match.node.text[1...-1].scan(/\\.|[^\\]+|\\/m).map { |piece| escape(piece) }
        string_node(pieces)
      end
    end

    def escape(piece)
      return piece unless piece.start_with?("\\")

      ESCAPES.fetch(piece[1]) { leaf(:escape, piece) }
    end

    # Build a literal if the string holds only text, and otherwise a string
    # node of literals and escapes. Join neighbouring text.
    def string_node(pieces)
      runs = pieces.chunk_while { |a, b| a.is_a?(String) && b.is_a?(String) }
      parts = runs.map { |run| run.first.is_a?(String) ? literal(run.join) : run.first }
      return literal("") if parts.empty?
      return parts.first if parts.one? && parts.first.type == "literal"

      build(:string, *parts)
    end

    # Write a bare key in a map as a string, because 8th's JSON reader reads
    # `{ a: 1 }` and `{ "a": 1 }` as the same map.
    def write_bare_keys_as_strings!
      transform(tree, "(key) @key") { |match| literal(match.node.text) }
    end
  end
end
