import Std.Data.HashMap

namespace Anagram

def findAnagrams (subject : String) (candidates : List String) : List String :=
  let subject := subject.toLower
  let subjHist := subject |> toHist
  candidates.filter (λ candidate =>
    let candidate := candidate.toLower
    candidate != subject && subjHist == (candidate |> toHist)
  )
  where
    toHist (s : String) : Std.HashMap Char USize :=
      s.foldl (λ set ch => set.alter ch λ
        | some v => some (v + 1)
        | none => some 1
      )
      (Std.HashMap.emptyWithCapacity)

end Anagram
