namespace PhoneNumber

-- Single-comparison ASCII digit test using unsigned wrap-around arithmetic.
@[inline] private def isDigitChar (c : Char) : Bool :=
  c.val - '0'.val ≤ 9

@[inline] private def isPunctChar (c : Char) : Bool :=
  c == '+' || c == ' ' || c == '-' || c == '.' || c == '(' || c == ')'

def clean (phrase : String) : Option String :=
  -- Accumulate digits; `none` latches on the first invalid character.
  let digitsOpt : Option (Array Char) :=
    phrase.foldl (fun acc c =>
      match acc with
      | none => none
      | some arr =>
        if isDigitChar c then some (arr.push c)
        else if isPunctChar c then some arr
        else none
    ) (some #[])
  digitsOpt.bind fun arr =>
    -- Determine the start offset after stripping country code '1' if present.
    let startOpt : Option Nat := match arr.size with
      | 11 => if arr[0]! == '1' then some 1 else none
      | 10 => some 0
      | _  => none
    startOpt.bind fun s =>
      -- Area code first digit (index s) and exchange code first digit (index s+3)
      -- must both be 2–9.
      if arr[s]! == '0' || arr[s]! == '1' then none
      else if arr[s + 3]! == '0' || arr[s + 3]! == '1' then none
      else some (String.ofList (arr.extract s (s + 10)).toList)

end PhoneNumber
