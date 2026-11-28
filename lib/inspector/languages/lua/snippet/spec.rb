# The website shows the first lines of each solution on its card. This file
# says what to leave out of a Lua solution's snippet, so that the card
# shows the student's own code. docs/snippets.md explains each declaration.
module Inspector::Languages::Lua::Snippet
  class Spec < Inspector::Engine::Snippet
    # Remove every comment, wherever it is.
    remove :comments # local x = 1 «-- The answer»
  end
end
