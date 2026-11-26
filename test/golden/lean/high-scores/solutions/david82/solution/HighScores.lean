namespace HighScores

def latestList (scores : List Nat) : Nat :=
  (scores.getLast?).getD 0

def latestArray (scores : Array Nat) : Nat :=
  scores.back?.getD 0

def personalBestList (scores : List Nat) : Nat :=
  scores.foldl max 0

def personalBestArray (scores : Array Nat) : Nat :=
  scores.foldl max 0

private def bumpTopThree (top : List Nat) (x : Nat) : List Nat :=
  let cands := x :: top
  let asc := cands.mergeSort fun a b => decide (a ≤ b)
  if asc.length < 4 then asc.reverse else asc.tail.reverse

def personalTopThreeList (scores : List Nat) : List Nat :=
  scores.foldl bumpTopThree []

def personalTopThreeArray (scores : Array Nat) : Array Nat :=
  scores.foldl bumpTopThree [] |>.toArray

end HighScores
               