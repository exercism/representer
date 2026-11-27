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
  end
end
