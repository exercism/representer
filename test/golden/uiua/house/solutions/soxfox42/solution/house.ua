Things ← [
  {"house" "Jack built"}
  {"malt" "lay in"}
  {"rat" "ate"}
  {"cat" "killed"}
  {"dog" "worried"}
  {"cow with the crumpled horn" "tossed"}
  {"maiden all forlorn" "milked"}
  {"man all tattered and torn" "kissed"}
  {"priest all shaven and shorn" "married"}
  {"rooster that crowed in the morn" "woke"}
  {"farmer sowing his corn" "kept"}
  {"horse and the hound and the horn" "belonged to"}
]
Part   ← |1 □$"the _ that _"⊃⊢⊣⊡:Things
Line   ← |1 □⊂:@.⊂"This is "⍣°□∘/◇(⊂⊂)@ ⇌≡Part⇡
Range  ← |2 +⇡+1⤚-
Recite ← |2 ≡Line Range
