# The website shows the first lines of each solution on its card. This file
# says what to leave out of a Raku solution's snippet, so that the card
# shows the student's own code. REPRESENTER_DSL.md explains each declaration.
module Representer
  module Languages
    class Raku
      class Snippet < Representer::Engine::Snippet
        # Remove every comment and docstring, wherever they are.
        remove :comments,   # my $x = 1; «# The answer»
               :docstrings  # «=begin pod» ... «=end pod»

        # Treat pod blocks as docstrings.
        docstrings_are { |node, _parent| node.type == "pod" }

        # Find the comments in a file that doesn't parse, by the way they start, because Rouge has no Raku lexer.
        comment_lines "#" # «# A comment»

        # Skip the unit declarations and imports at the top of the file, up to the first other statement.
        skip_at_top :unit, # «unit module Leap;»
                    :use   # «use v6;»
      end
    end
  end
end
