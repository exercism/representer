namespace Allergies

inductive Allergen where
  | eggs : Allergen
  | peanuts : Allergen
  | shellfish : Allergen
  | strawberries : Allergen
  | tomatoes : Allergen
  | chocolate : Allergen
  | pollen : Allergen
  | cats : Allergen
  deriving BEq, Repr, DecidableEq

def allergicTo (allergen : Allergen) (score : Nat) : Bool :=
  let bit := 1 <<< allergen.ctorIdx
  score &&& bit != 0

def list (score : Nat) : List Allergen := Id.run do
  let mut result := #[]
  for n in (Allergen.eggs.ctorIdx ...= Allergen.cats.ctorIdx) do
    let allergen := Allergen.ofNat n
    if allergicTo allergen score then
      result := result.push allergen
  pure result.toList

end Allergies
