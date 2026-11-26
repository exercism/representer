namespace House

abbrev VerseIndex := { x : Nat // 1 ≤ x ∧ x ≤ 12 }

def VerseIndex.toNat (verse : VerseIndex) : Nat
  := verse.val - 1

def whoDidWhat : Array (String × String) := #[
  ("malt", "lay in"),
  ("rat", "ate"),
  ("cat", "killed"),
  ("dog", "worried"),
  ("cow with the crumpled horn", "tossed"),
  ("maiden all forlorn", "milked"),
  ("man all tattered and torn", "kissed"),
  ("priest all shaven and shorn", "married"),
  ("rooster that crowed in the morn", "woke"),
  ("farmer sowing his corn", "kept"),
  ("horse and the hound and the horn", "belonged to"),
]

private def start : (String × List String)
  := ("the house that Jack built.", [])

private def step (rest : String × List String) (prev : Nat)  : (String × List String) :=
  let (who, did) := whoDidWhat[prev]!
  let (first, lines) := rest
  (s!"the {who}", s!"that {did} {first}" :: lines)

private def finish (lines : (String × List String)) : String :=
  " ".intercalate (("This is " ++ lines.fst) :: lines.snd)

/-
private def compose (verse : Nat) : (String × List String) :=
  match verse with
  | 0 =>        ("the house that Jack built.", [])
  | prev + 1 => step (compose prev) prev

#eval compose 0
#eval compose 4
-/

def recite (startVerse endVerse : VerseIndex) : String :=
  List.range endVerse.toNat
    |>.scanl (fun acc idx => step acc idx) start
    |>.map finish
    |>.drop startVerse.toNat
    |> "\n\n".intercalate

end House

-- #eval House.recite ⟨ 1, by decide ⟩  ⟨ 1, by decide ⟩ 
-- #eval House.recite ⟨ 2, by decide ⟩  ⟨ 4, by decide ⟩ 
