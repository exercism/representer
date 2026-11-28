# The website shows the first lines of each solution on its card. This file
# says what to leave out of a Python solution's snippet, so that the card
# shows the student's own code. docs/dsl.md explains each declaration.
module Representer::Languages::Python::Snippet
  class Spec < Representer::Engine::Snippet
    # Remove every comment and docstring, wherever they are.
    remove :comments,   # x = 1 «# The answer»
           :docstrings  # «"""Says hello."""»

    # Skip the imports at the top of the file, up to the first other statement.
    skip_at_top :import, # «import os»
                :from    # «from math import pi»

    # Treat a string on its own in a module, class or function body as a
    # docstring. The language's common/spec.rb can't declare it with a code
    # pattern, because the grammar has no node for a statement that is only an
    # expression.
    def self.docstring?(node, parent) = node.type == "string" && parent&.type.to_s.match?(/\A(module|block)\z/)
  end
end
