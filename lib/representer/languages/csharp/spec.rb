# This file says what C# is and how the representer reads its files.
# REPRESENTER_DSL.md explains each declaration. representation.rb and
# snippet.rb hold the settings of each output, and the folders hold C#'s
# stages.
module Representer::Languages::CSharp
  class Spec < Representer::Engine::Language
    tracks "csharp"
    grammar "c_sharp"
    extensions ".cs"

    # Treat these as comments.
    comments_are :comment # int x = 1; «// The answer»
  end
end
