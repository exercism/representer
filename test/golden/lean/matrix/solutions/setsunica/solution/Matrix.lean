namespace Matrix

def toMat (xs : String) : List (List Nat) :=
  xs.splitOn "\n" |>.map (·.splitOn |>.map (·.toNat!))

def row (xs : String) (n : Nat) : List Nat := (toMat xs)[n - 1]!

def column (xs : String) (n : Nat) : List Nat :=
  toMat xs |>.foldr (λ l acc => l[n - 1]! :: acc) []

end Matrix