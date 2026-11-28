module Inspector::Languages::Euphoria::Common
  class Spec < Inspector::Engine::Language
    tracks "euphoria"
    grammar "euphoria"
    extensions ".ex", ".e"

    # Treat these as comments.
    comments_are :comment, # integer x = 1 «-- The answer»
                 :shebang  # «#!/usr/bin/env eui»
  end
end
