namespace Yacht

inductive Category where
  | ones | twos | threes | fours | fives | sixes
  | choice | fourOfAKind | fullHouse | yacht
  | littleStraight | bigStraight
  deriving BEq, Repr

abbrev Die   := { x : Nat // 1 ≤ x ∧ x ≤ 6 }
abbrev Throw := Vector Die 5

def select (n : Nat) (sorted : Array Nat) : Nat :=
  let add (acc : Nat) (die : Nat) : Nat :=
    if die == n then acc + die else acc
  Array.foldl add 0 sorted

def total (sorted : Array Nat) : Nat :=
  let add (acc : Nat) (die : Nat) : Nat :=
    acc + die
  Array.foldl add 0 sorted

def foak (sorted : Array Nat) : Nat :=
  if sorted[0]! == sorted[3]! then 4 * sorted[0]!
  else if sorted[1]! == sorted[4]! then 4 * sorted[1]!
  else 0

def fh (sorted : Array Nat) : Nat :=
  if sorted[0]! == sorted[4]! then 0
  else if sorted[0]! != sorted[1]! then 0
  else if sorted[3]! != sorted[4]! then 0
  else if (sorted[1]! == sorted[2]!) then total sorted
  else if (sorted[2]! == sorted[3]!) then total sorted
  else 0

def y (sorted : Array Nat) : Nat :=
  if sorted[0]! == sorted[4]! then 50 else 0

def ls (sorted : Array Nat) : Nat :=
  if sorted == #[1, 2, 3, 4, 5] then 30 else 0

def bs (sorted : Array Nat) : Nat :=
  if sorted == #[2, 3, 4, 5, 6] then 30 else 0

def score (dice : Throw) (category: Category) : Nat :=
  let sorted := Array.qsort dice.toArray (fun a b => a.val <= b.val) |> Array.map (·.val)
  match category with
  | .ones => select 1 sorted
  | .twos => select 2 sorted
  | .threes => select 3 sorted
  | .fours => select 4 sorted
  | .fives => select 5 sorted
  | .sixes => select 6 sorted
  | .choice => total sorted
  | .fourOfAKind => foak sorted
  | .fullHouse => fh sorted
  | .yacht => y sorted
  | .littleStraight => ls sorted
  | .bigStraight => bs sorted

end Yacht
