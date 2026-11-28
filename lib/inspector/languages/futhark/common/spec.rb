module Inspector::Languages::Futhark::Common
  class Spec < Inspector::Engine::Language
    tracks "futhark"
    grammar "futhark"
    extensions ".fut"

    # Treat these as comments, including documentation comments.
    comments_are :comment # def x = 1 «-- The answer»
  end
end
