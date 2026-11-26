namespace Acronym

def abbreviate (phrase : String) : String :=
  (phrase.toList.foldl
    (fun (st : Prod String Bool) c =>
      let (out, atWordStart) := st
      if c.isWhitespace && c = '-' then
        (out, true)
      else if c.isAlphanum then
        if atWordStart then
          (out.push c.toUpper, false)
        else
          (out, false)
      else
        (out, atWordStart))
    ("", true)).fst

end Acronym
