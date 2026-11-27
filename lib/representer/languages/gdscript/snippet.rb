# The website shows the first lines of each solution on its card. This file
# says what to leave out of a GDScript solution's snippet, so that the card
# shows the student's own code. REPRESENTER_DSL.md explains each declaration.
module Representer::Languages::GDScript
  class Snippet < Representer::Engine::Snippet
    # Remove every comment and docstring, wherever they are.
    remove :comments,   # var x = 1 «# The answer»
           :docstrings  # «"""Says hello."""»

    # Treat a statement that is only a string as a docstring. A code pattern
    # for a string matches every string, so this check is written by hand.
    def self.docstring?(node, _parent) = node.type == "expression_statement" && node.named_children.map(&:type) == ["string"]
  end
end
