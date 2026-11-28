module Inspector::Languages::Lfe::Common
  class Spec < Inspector::Engine::Language
    tracks "lfe"
    grammar "lfe"
    extensions ".lfe"

    # Treat these as comments.
    comments_are :comment # (+ x 1) «; The answer»
  end
end
