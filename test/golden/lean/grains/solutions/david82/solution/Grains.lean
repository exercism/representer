namespace Grains

private def grainsBySquare : Array Nat :=
  (List.range 64).foldl (fun arr i => arr.push ((2 : Nat) ^ i)) #[]

def grains (square : Int) : Option Nat :=
  if square < 1 ∨ square > 64 then
    none
  else
    -- Index is in-range after the guard (`square.toNat` is 1 … 64).
    some (grainsBySquare[square.toNat - 1]!)

def totalGrains : Nat :=
  2 ^ 64 - 1

end Grains
     