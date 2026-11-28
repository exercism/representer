module Rosetta::Languages::JavaScript::Common
  class Spec < Rosetta::Engine::Language
    tracks "javascript"
    grammar "javascript"
    extensions ".js", ".mjs", ".cjs", ".jsx"

    # Treat these as comments.
    comments_are :comment # const x = 1; «// The answer»
  end
end
