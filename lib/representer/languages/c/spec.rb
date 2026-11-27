module Representer::Languages::C
  class Spec < Representer::Engine::Language
    tracks "c"
    grammar "c"
    extensions ".c", ".h"

    # Treat these as comments.
    comments_are :comment # int x = 1; «// The answer»
  end
end
