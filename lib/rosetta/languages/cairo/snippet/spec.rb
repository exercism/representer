# The website shows the first lines of each solution on its card. This file
# says what to leave out of a Cairo solution's snippet, so that the card
# shows the student's own code. docs/snippets.md explains each declaration.
module Rosetta::Languages::Cairo::Snippet
  class Spec < Rosetta::Engine::Snippet
    # Remove every comment, wherever it is.
    remove :comments # let x = 1; «// The answer»

    # Find the comments in a file that doesn't parse, by the way they start, because Rouge has no Cairo lexer.
    comment_lines "//" # «// A comment»

    # Skip the imports at the top of the file, up to the first other statement.
    skip_at_top :use # «use core::num::traits::Pow;»
  end
end
