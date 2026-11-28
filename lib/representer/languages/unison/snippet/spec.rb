# The website shows the first lines of each solution on its card. This file
# says what to leave out of a Unison solution's snippet, so that the card
# shows the student's own code. docs/dsl.md explains each declaration.
module Representer::Languages::Unison::Snippet
  class Spec < Representer::Engine::Snippet
    tracks "unison"

    # Remove every comment, wherever it is.
    remove :comments # x = 1 «-- The answer»

    # Skip the use clauses at the top of the file, up to the first other statement.
    skip_at_top :use # «use List map»
  end
end
