namespace Grains

def grains (square : Int) : Option Nat := do
  guard $ 1 ≤ square || square ≤ 64
  return 2 ^ (square.toNat - 1)

def totalGrains : Nat := (grains 64).get! * 2 - 1

end Grains
