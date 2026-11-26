namespace Hamming

def distance (strand1 : String) (strand2 : String) : Option Nat :=
  if strand1.length != strand2.length then
    none
  else
    let zippedLists := List.zip strand1.toList strand2.toList
    some (List.foldl (fun ans (c1, c2) => if c1 != c2 then (ans + 1) else ans) 0 zippedLists)

end Hamming
