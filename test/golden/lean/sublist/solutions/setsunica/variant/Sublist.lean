namespace Sublist

inductive Classification where
  | sublist | superlist | equal | unequal
  deriving BEq, Repr

def sublist (listOne listTwo : List Nat) : Classification :=
  if listOne.length != listTwo.length then if listOne == listTwo then .equal else .unequal
  else if listOne.length < listTwo.length then
    if isInfixOf listOne listTwo then .sublist else .unequal
  else
    if isInfixOf listTwo listOne then .superlist else .unequal
  where
    isInfixOf (l₁ l₂ : List Nat) : Bool := l₁.isPrefixOf l₂ || match l₂ with
      | []       => false
      | _ :: xs  => isInfixOf l₁ xs

end Sublist