namespace Luhn

def valid (value : String) : Bool :=
  let chars := value.toList.filter (· != ' ')
  let digits? : Option (List Nat):= do
    guard (chars.all Char.isDigit && chars.length > 1)
    chars.map (·.toNat - '0'.toNat)

  match digits? with
  | none=> false
  | some digits =>
    digits.reverse.mapIdx (fun i x =>
      if i % 2 == 1 then
        let d := x * 2
        if d > 9 then d - 9 else d
      else
        x
    ) |> (·.sum % 10 == 0)

end Luhn
