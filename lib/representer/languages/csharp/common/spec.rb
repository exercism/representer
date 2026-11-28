module Representer::Languages::CSharp::Common
  class Spec < Representer::Engine::Language
    tracks "csharp"
    grammar "c_sharp"
    extensions ".cs"

    # Treat these as comments.
    comments_are :comment # int x = 1; «// The answer»
  end
end
