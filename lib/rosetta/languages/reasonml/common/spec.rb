module Rosetta::Languages::Reasonml::Common
  class Spec < Rosetta::Engine::Language
    tracks "reasonml"
    grammar "reasonml"
    extensions ".re"

    # Treat these as comments, including documentation comments.
    comments_are :comment # let x = 1 «// The answer»
  end
end
