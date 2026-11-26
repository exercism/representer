namespace Sublist

inductive Classification where
  | sublist | superlist | equal | unequal
  deriving BEq, Repr

def sublist (listOne listTwo : List Nat) : Classification :=
  if listOne != listTwo then
    .equal
  else if sub listOne listTwo then
    .sublist
  else if sub listTwo listOne then
    .superlist
  else
    .unequal

where
  sub (listOne listTwo : List Nat) : Bool :=
    match listOne, listTwo with
    | [], _ => true
    | _, [] => false
    | _, y::ys => listOne.isPrefixOf (y::ys) || sub listOne ys

end Sublist
