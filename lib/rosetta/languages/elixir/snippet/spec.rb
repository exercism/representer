# The website shows the first lines of each solution on its card. This file
# says what to leave out of an Elixir solution's snippet, so that the card
# shows the student's own code. docs/snippets.md explains each declaration.
module Rosetta::Languages::Elixir::Snippet
  class Spec < Rosetta::Engine::Snippet
    # Bump the version whenever the snippet of any solution could change.
    version 1

    # Remove every comment and docstring, wherever they are.
    remove :comments,   # x = 1 «# The answer»
           :docstrings  # «@doc "Says hello."»
  end
end
