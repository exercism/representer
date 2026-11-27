module Representer::Languages::Go
  class Spec < Representer::Engine::Language
    tracks "go"
    grammar "go"
    extensions ".go"

    # Treat these as comments.
    comments_are :comment # x := 1 «// The answer»
  end
end
