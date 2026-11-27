# The website shows the first lines of each solution on its card. This file
# says what to leave out of a jq solution's snippet, so that the card
# shows the student's own code. REPRESENTER_DSL.md explains each declaration.
module Representer::Languages::Jq
  class Snippet < Representer::Engine::Snippet
    tracks "jq"

    # Remove every comment, wherever it is.
    remove :comments # .x «# The answer»

    # Find the comments by the way they start, because Rouge has no jq lexer.
    comment_lines "#" # «# A comment»
  end
end
