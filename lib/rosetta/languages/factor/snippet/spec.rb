# The website shows the first lines of each solution on its card. This file
# says what to leave out of a Factor solution's snippet, so that the card
# shows the student's own code. docs/snippets.md explains each declaration.
module Rosetta::Languages::Factor::Snippet
  class Spec < Rosetta::Engine::Snippet
    # Work on lines, because the grammar doesn't know Factor's comments, and Rouge's Factor lexer does.
    lines_only

    # Remove every comment, wherever it is.
    remove :comments # : answer ( -- n ) 42 ; «! The answer»
  end
end
