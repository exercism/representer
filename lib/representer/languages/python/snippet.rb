# The website shows the first lines of each solution on its card. This file
# says what to leave out of a Python solution's snippet, so that the card
# shows the student's own code. REPRESENTER_DSL.md explains each declaration.
module Representer
  module Languages
    class Python
      class Snippet < Representer::Engine::Snippet
        # Remove every comment and docstring, wherever they are.
        remove :comments,   # x = 1 «# The answer»
               :docstrings  # «"""Says hello."""»

        # Treat a string on its own in a module, class or function body as a docstring.
        docstrings_are { |node, parent| node.type == "string" && %w[module block].include?(parent&.type) }

        # Skip the imports at the top of the file, up to the first other statement.
        skip_at_top :import, # «import os»
                    :from    # «from math import pi»
      end
    end
  end
end
