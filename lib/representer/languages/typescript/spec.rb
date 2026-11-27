module Representer::Languages::TypeScript
  class Spec < Representer::Engine::Language
    tracks "typescript"
    grammar "typescript"
    extensions ".ts", ".mts", ".cts", ".tsx"

    # Treat these as comments.
    comments_are :comment # const x = 1; «// The answer»
  end
end
