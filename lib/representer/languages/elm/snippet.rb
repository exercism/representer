# The website shows the first lines of each solution on its card. This file
# says what to leave out of an Elm solution's snippet, so that the card
# shows the student's own code. REPRESENTER_DSL.md explains each declaration.
module Representer
  module Languages
    class Elm
      class Snippet < Representer::Engine::Snippet
        # Remove every comment, wherever it is.
        remove :comments # x = 1 «-- The answer»

        # Skip the module declaration and imports at the top of the file, up to the first other statement.
        skip_at_top :module, # «module Leap exposing (isLeapYear)»
                    :import  # «import List»
      end
    end
  end
end
