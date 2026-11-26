import Std

namespace Etl

def f (init: Std.HashMap Char Nat) (α: Nat) (β: (List Char)) : Std.HashMap Char Nat :=
  β.foldl (·.insert ·.toLower α) init


def transform (legacy : Std.HashMap Nat (List Char)) : Std.HashMap Char Nat :=
  let init := Std.HashMap.emptyWithCapacity
  Std.HashMap.fold f init legacy

end Etl

#eval Etl.transform (.ofList [
  (1, ['A', 'E', 'I', 'O', 'U', 'L', 'N', 'R', 'S', 'T']),
  (2, ['D', 'G']),
  (3, ['B', 'C', 'M', 'P']),
  (4, ['F', 'H', 'V', 'W', 'Y']),
  (5, ['K']),
  (8, ['J', 'X']),
  (10, ['Q', 'Z'])
])
