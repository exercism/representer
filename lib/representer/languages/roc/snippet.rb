# The website shows the first lines of each solution on its card. This file
# says what to leave out of a Roc solution's snippet, so that the card
# shows the student's own code. REPRESENTER_DSL.md explains each declaration.
module Representer::Languages::Roc
  class Snippet < Representer::Engine::Snippet
    tracks "roc"

    # Remove every comment, wherever it is.
    remove :comments # x = 1 «# The answer»

    # Find the comments by the way they start, because Rouge has no Roc lexer.
    comment_lines "#" # «# A comment»

    # Skip the module header and imports at the top of the file, up to the first other statement.
    skip_at_top :module, # «module [isLeapYear]»
                :import  # «import Helpers»
  end
end
