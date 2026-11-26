namespace ReverseString

def reverse (value : String) : String :=
  let rec helper (l : List Char) (reversed : List Char) := match l with
  | [] => reversed
  | (first :: rest) => helper rest (last :: reversed)

  (helper value.toList []).asString

end ReverseString
