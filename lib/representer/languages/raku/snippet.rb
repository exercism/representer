# The website shows the first lines of each solution on its card. This file
# says what to leave out of a Raku solution's snippet, so that the card
# shows the student's own code. REPRESENTER_DSL.md explains each declaration.
module Representer::Languages::Raku
  class Snippet < Representer::Engine::Snippet
    # Bump the version whenever the snippet of any solution could change.
    version 1

    # Remove every comment, wherever it is. Spec.rb counts pod blocks as comments.
    remove :comments # my $x = 1; «# The answer»

    # Find the comments in a file that doesn't parse, by the way they start, because Rouge has no Raku lexer.
    comment_lines "#" # «# A comment»

    # Skip the unit declarations and imports at the top of the file, up to the first other statement.
    skip_at_top :unit, # «unit module Leap;»
                :use   # «use v6;»
  end
end
