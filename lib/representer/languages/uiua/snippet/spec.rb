# The website shows the first lines of each solution on its card. This file
# says what to leave out of a Uiua solution's snippet, so that the card
# shows the student's own code. REPRESENTER_DSL.md explains each declaration.
module Representer::Languages::Uiua::Snippet
  class Spec < Representer::Engine::Snippet
    tracks "uiua"

    # Remove every comment, wherever it is.
    remove :comments # X ← 1 «# The answer»

    # Find the comments by the way they start, because Rouge has no Uiua lexer.
    comment_lines "#" # «# A comment»
  end
end
