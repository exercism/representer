namespace Acronym

def abbreviate (phrase : String) : String :=
  let (acc, _) :=
    phrase.foldl (init := ("", true)) fun (acc, atWordStart) c =>
      if c ∈ [' ', '-'] then
        (acc, true)
      else if c.isAlpha then
        ((if atWordStart then acc.push c.toUpper else acc), false)
      else
        (acc, atWordStart)
  acc

end Acronym
