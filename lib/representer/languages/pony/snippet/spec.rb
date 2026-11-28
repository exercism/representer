# The website shows the first lines of each solution on its card. This file
# says what to leave out of a Pony solution's snippet, so that the card
# shows the student's own code. docs/dsl.md explains each declaration.
module Representer::Languages::Pony::Snippet
  class Spec < Representer::Engine::Snippet
    tracks "pony"

    # Remove every comment, wherever it is.
    remove :comments # let x: U32 = 1 «// The answer»

    # Skip the imports at the top of the file, up to the first other statement.
    skip_at_top :use # «use "collections"»
  end
end
