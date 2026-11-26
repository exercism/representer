namespace KindergartenGarden

inductive Plant where
  | grass | clover | radishes | violets
  deriving BEq, Repr, Inhabited

inductive Child where
  | alice
  | bob
  | charlie
  | david
  | eve
  | fred
  | ginny
  | harriet
  | ileana
  | joseph
  | kincaid
  | larry
  deriving BEq, Repr, Inhabited

def Plant.fromChar : Char → Option Plant
  | 'C' => some .clover
  | 'G' => some .grass
  | 'R' => some .radishes
  | 'V' => some .violets
  | _ => none

def Child.fromString : String → Option Child
  | "Alice" => some .alice
  | "Bob" => some .bob
  | "Charlie" => some .charlie
  | "David" => some .david
  | "Eve" => some .eve
  | "Fred" => some .fred
  | "Ginny" => some .ginny
  | "Harriet" => some .harriet
  | "Ileana" => some .ileana
  | "Joseph" => some .joseph
  | "Kincaid" => some .kincaid
  | "Larry" => some .larry
  | _ => none

def Child.cupColumnStart (child : Child) : Nat :=
  child.ctorIdx * 2

def cupsAt (startPos : Nat) (s : String.Slice) : Option (Array Plant) :=
  s.drop startPos |>.take 2 |>.chars.mapM Plant.fromChar |>.toArray

def plants? (diagram student : String) : Option (Vector Plant 4) := do
  let startPos := (← Child.fromString student).cupColumnStart
  let cups ← diagram.split '\n' |>.toArray |>.flatMapM (cupsAt startPos)
  if h : cups.size = 4 then pure ⟨cups, h⟩ else none

def plants (diagram student : String) : Vector Plant 4 :=
  match plants? diagram student with
  | some plants => plants
  | none => panic! "invalid plant or child"

end KindergartenGarden
