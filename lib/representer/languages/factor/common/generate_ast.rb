# REPRESENTER_DSL.md and WRITING_GENERATE_AST.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# a simpler tree. Factor code is mostly a flat list of words, and the grammar
# only gives structure to definitions, quotations, collections and `:>`
# bindings.
module Representer::Languages::Factor::Common
  class GenerateAST < Representer::Engine::GenerateAST
    # Strip the brackets, the stack effect's `--` and the `;` that ends a
    # definition, because the node types already show them.
    # : f ( a -- b ) [ dup + ] ;  ->  (definition : f (effect (inputs a) (outputs b)) (quote dup +))
    strip_tokens "(", ")", "--", "[", "]", "{", "}", ";"

    # Write each number as its value. Factor separates digits with `,` or
    # `_`.
    #
    # 1,000  ->  1000
    # 0x1F  ->  31
    # 1.50  ->  1.5
    numbers_are integer: [:base10, :base16],
                decimal: :float,
                separators: ["_", ","]

    def call
      tree.tap do
        mark_the_name_of_each_definition!
        group_each_import_with_its_words!
      end
    end

    private
    # Mark the word after `:` or `::` as the definition's name, so that
    # representation.rb can list it.
    # : «double» ( n -- m ) 2 * ;
    def mark_the_name_of_each_definition!
      each_node(tree) do |node, _|
        node.named_children.find { |child| child.type == "symbol" }.field = "name" if node.type == "definition"
      end
    end

    # Put the words of each `USING: ... ;` and `USE: word` in a node of its
    # own, so that the representation can drop them as imports. The grammar
    # reads them as plain words.
    # USING: kernel math ;  ->  (using kernel math)
    # USE: io  ->  (use io)
    def group_each_import_with_its_words!
      words = tree.children
      tree.children = []
      tree.children << next_import_or_word!(words) until words.empty?
    end

    def next_import_or_word!(words)
      word = words.shift
      case word_text(word)
      when "USING:" then build(:using, *take_words_until_semicolon!(words))
      when "USE:" then build(:use, *words.shift(1))
      else word
      end
    end

    def take_words_until_semicolon!(words)
      taken = []
      taken << words.shift until words.empty? || word_text(words.first) == ";"
      words.shift
      taken
    end

    def word_text(node) = node.type == "symbol" ? node.text : nil
  end
end
