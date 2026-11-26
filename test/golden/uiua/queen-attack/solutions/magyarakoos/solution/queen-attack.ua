┌─╴Queen
  # Create a new queen
  # Queen ? Row Column
  New ←⊓(⍤"invalid row"|⍤"invalid column"|⊂)◡∩(∊⇡8)
  
  # Get a queen's row
  # Row ? Queen
  Row ← fir
  
  # Get a queen's column
  # Column ? Queen
  Column ← las
  
  # Check if two queens can attack each other
  # Validity ? Queen1 Queen2
  CanAttack ←↥=0⊃/↧/=⌵-

└─╴
