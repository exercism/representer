namespace LargestSeriesProduct

def largestProductList (span : Nat) (digits : String) : Option Nat :=
  let chars := digits.toList
  if chars.any (fun c => !c.isDigit) then none
  else if span == 0 then some 1
  else if span > chars.length then none
  else
    let vals := chars.map (fun c => c.toNat - '0'.toNat)
    let windows := vals.length - span + 1
    let best := (List.range windows).foldl (fun acc i =>
      let window := vals.drop i |>.take span
      let prod := window.foldl (· * ·) 1
      Nat.max acc prod
    ) 0
    some best

def largestProduct (span : Nat) (digits : String) : Option Nat :=
  
  let parsed : Option (Array Nat) := digits.foldl (fun acc c =>
    match acc with
    | none   => none
    | some a => if c.isDigit then some (a.push (c.toNat - '0'.toNat)) else none
  ) (some #[])
  match parsed with
  | none      => none
  | some vals =>
    if span == 0 then some 1
    else if span > vals.size then none
    else
      let windows := vals.size - span + 1
      
      let best := (List.range windows).foldl (fun acc i =>
        let prod := (List.range span).foldl (fun p j => p * vals[i + j]!) 1
        Nat.max acc prod
      ) 0
      some best

end LargestSeriesProduct
