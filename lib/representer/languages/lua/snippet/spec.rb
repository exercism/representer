# The website shows the first lines of each solution on its card. This file
# says what to leave out of a Lua solution's snippet, so that the card
# shows the student's own code. docs/snippets.md explains each declaration.
module Representer::Languages::Lua::Snippet
  class Spec < Representer::Engine::Snippet
    # Remove every comment, wherever it is.
    remove :comments # local x = 1 «-- The answer»
  end
end
