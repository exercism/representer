namespace Hamming

private def countDiffEqualLength (strand1 strand2 : String) : Nat :=
  (strand1.foldl
      (fun (it2, acc) c1 =>
        let c2 := String.Legacy.Iterator.curr it2
        let acc' := if c1 = c2 then acc else acc + 1
        (String.Legacy.Iterator.next it2, acc'))
      (String.Legacy.mkIterator strand2, 0)).2

def distance (strand1 : String) (strand2 : String) : Option Nat :=
  if strand1.length = strand2.length then
    some (countDiffEqualLength strand1 strand2)
  else
    none

end Hamming
           