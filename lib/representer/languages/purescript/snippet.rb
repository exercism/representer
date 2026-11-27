# The website shows the first lines of each solution on its card. This file
# says what to leave out of a PureScript solution's snippet, so that the card
# shows the student's own code. REPRESENTER_DSL.md explains each declaration.
module Representer::Languages::PureScript
  class Snippet < Representer::Engine::Snippet
    # Bump the version whenever the snippet of any solution could change.
    version 2

    # Work on lines, because the grammar gives the module header as tokens
    # of the file, with no statement of its own to skip.
    lines_only

    # Remove every comment, wherever it is.
    remove :comments # x = 1 «-- The answer»

    # Skip the module header and the imports at the top of the file, up to
    # the first other statement.
    skip_at_top :module, # «module Leap (isLeapYear) where»
                :import  # «import Prelude»
  end
end
