┌─╴Queen
  # Create a new queen
  # Queen ? Row Column
  New ← |2 ⊟⊓(⍤"invalid row"|⍤"invalid column") ◡∩(∊⇡8)

  # Get a queen's row
  # Row ? Queen
  Row ← |1 ⊢

  # Get a queen's column
  # Column ? Queen
  Column ← |1 ⊣

  # Check if two queens can attack each other
  # Validity ? Queen1 Queen2
  CanAttack ← |2 +⊃(=1/+=|/=⌵-?)
└─╴