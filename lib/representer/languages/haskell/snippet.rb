# The website shows the first lines of each solution on its card. This file
# says what to leave out of a Haskell solution's snippet, so that the card
# shows the student's own code. REPRESENTER_DSL.md explains each declaration.
module Representer::Languages::Haskell
  class Snippet < Representer::Engine::Snippet
    tracks "haskell"

    # Remove every comment, wherever it is.
    remove :comments # x = 1 «-- The answer»

    # Skip the module header and imports at the top of the file, up to the first other statement.
    skip_at_top :module, # «module Leap (isLeapYear) where»
                :import  # «import Data.List (sort)»
  end
end
