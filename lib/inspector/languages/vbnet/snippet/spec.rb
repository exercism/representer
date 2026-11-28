# The website shows the first lines of each solution on its card. This file
# says what to leave out of a VB.NET solution's snippet, so that the card
# shows the student's own code. docs/snippets.md explains each declaration.
module Inspector::Languages::VBNet::Snippet
  class Spec < Inspector::Engine::Snippet
    tracks "vbnet"

    # Remove every comment, wherever it is.
    remove :comments # Dim x = 1 «' The answer»

    # Skip the imports at the top of the file, up to the first other statement.
    skip_at_top :Imports # «Imports System»
  end
end
