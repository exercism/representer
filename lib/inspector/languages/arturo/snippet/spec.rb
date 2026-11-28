# The website shows the first lines of each solution on its card. This file
# says what to leave out of an Arturo solution's snippet, so that the card
# shows the student's own code. docs/snippets.md explains each declaration.
module Inspector::Languages::Arturo::Snippet
  class Spec < Inspector::Engine::Snippet
    tracks "arturo"

    # Remove every comment, wherever it is.
    remove :comments # x: 1 «; The answer»

    # Find the comments by the way they start, because Rouge has no Arturo lexer.
    comment_lines ";" # «; A comment»
  end
end
