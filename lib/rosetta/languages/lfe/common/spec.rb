module Rosetta::Languages::Lfe::Common
  class Spec < Rosetta::Engine::Language
    tracks "lfe"
    grammar "lfe"
    extensions ".lfe"

    # Treat these as comments.
    comments_are :comment # (+ x 1) «; The answer»
  end
end
