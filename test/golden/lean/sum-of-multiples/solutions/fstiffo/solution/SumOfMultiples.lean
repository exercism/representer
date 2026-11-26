import Std.Data.HashSet

open Std

namespace SumOfMultiples

def multiples (factor : Nat) (limit : Nat) : List UInt64 :=
  List.range' factor ((limit-1)/factor) (step := factor)
  |> List.map (·.toUInt64)

def sum (factors : List UInt64) (limit : UInt64) : UInt64 :=
  factors.flatMap (fun f => multiples f.toNat limit.toNat)
  |> HashSet.ofList
  |> HashSet.fold (· + ·) 0

end SumOfMultiples

#eval SumOfMultiples.sum [3,5] 20

#eval SumOfMultiples.multiples 3 45

#eval ↑20
