module Rosetta::Languages::Lean::Common
  class Spec < Rosetta::Engine::Language
    tracks "lean"
    grammar "lean"
    extensions ".lean"

    # Treat these as comments, including `/-- -/` documentation.
    comments_are :comment,      # def x := 1 «-- The answer»
                 :block_comment # «/- The answer -/»
  end
end
