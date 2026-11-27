# The website shows the first lines of each solution on its card. This file
# says what to leave out of the snippet for every track with no snippet of
# its own. REPRESENTER_DSL.md explains each declaration.
module Representer
  module Languages
    class Basic
      class Snippet < Representer::Engine::Snippet
        # Remove the comments found by the track's Rouge lexer, if it has one.
        remove :comments # x = 1 «# The answer»
      end
    end
  end
end
