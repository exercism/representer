module Representer::Languages::Idris
  class Snippet < Representer::Engine::Snippet
    # Bump the version whenever the snippet of any solution could change.
    version 2

    # Remove every comment, wherever it is.
    remove :comments # x = 1 «-- The answer»

    # Skip the module header, the imports and the `%default` pragma at the
    # top of the file, up to the first other statement.
    skip_at_top :module,   # «module Leap»
                :import,   # «import Data.List»
                "%default" # «%default total»
  end
end
