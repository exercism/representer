# The website shows the first lines of each solution on its card. This file
# says what to leave out of a Futhark solution's snippet, so that the card
# shows the student's own code. docs/dsl.md explains each declaration.
module Representer::Languages::Futhark::Snippet
  class Spec < Representer::Engine::Snippet
    tracks "futhark"

    # Remove every comment, wherever it is.
    remove :comments # let x = 1 «-- The answer»

    # Find the comments by the way they start, because Rouge has no Futhark lexer.
    comment_lines "--" # «-- A comment»
  end
end
