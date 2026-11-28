module Inspector::Languages::Prolog::Common
  class Spec < Inspector::Engine::Language
    tracks "prolog"
    grammar "prolog"
    extensions ".pl"

    # Treat these as comments.
    comments_are :comment # X = 1, «% The answer»
  end
end
