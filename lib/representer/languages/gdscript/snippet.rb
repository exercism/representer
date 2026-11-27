# The website shows the first lines of each solution on its card. This file
# says what to leave out of a GDScript solution's snippet, so that the card
# shows the student's own code. REPRESENTER_DSL.md explains each declaration.
module Representer
  module Languages
    class GDScript
      class Snippet < Representer::Engine::Snippet
        # Remove every comment and docstring, wherever they are.
        remove :comments,   # var x = 1 «# The answer»
               :docstrings  # «"""Says hello."""»

        # Treat region markers as comments.
        comment_types :region_start, # «#region Helpers»
                      :region_end    # «#endregion»

        # Treat a statement that is only a string as a docstring.
        docstrings_are { |node, _parent| node.type == "expression_statement" && node.named_children.map(&:type) == ["string"] }
      end
    end
  end
end
