def critter (n: i32): []u8 =
  match n
  case 1 -> "house that Jack built."
  case 2 -> "malt"
  case 3 -> "rat"
  case 4 -> "cat"
  case 5 -> "dog"
  case 6 -> "cow with the crumpled horn"
  case 7 -> "maiden all forlorn"
  case 8 -> "man all tattered and torn"
  case 9 -> "priest all shaven and shorn"
  case 10 -> "rooster that crowed in the morn"
  case 11 -> "farmer sowing his corn"
  case 12 -> "horse and the hound and the horn"
  case _ -> assert false "gremlin"

def action (n: i32): []u8 =
  match n
  case 1 -> "lay in"
  case 2 -> "ate"
  case 3 -> "killed"
  case 4 -> "worried"
  case 5 -> "tossed"
  case 6 -> "milked"
  case 7 -> "kissed"
  case 8 -> "married"
  case 9 -> "woke"
  case 10 -> "kept"
  case 11 -> "belonged to"
  case _ -> assert false "flummoxed"

def intro(n: i32): []u8 = "This is the " ++ critter n

def cascade(n: i32): []u8 =
  loop line = ""
    for i < n - 1 do
      line ++ " that " ++ action (n - i - 1) ++ " the " ++ critter (n - i + 1)

def verse(n: i32): []u8 = intro n ++ cascade n ++ ['\n']

def recite (start_verse: i32) (end_verse: i32): []u8 =
  loop lines = ""
    for i < end_verse - start_verse + 1 do lines ++ verse (start_verse + i)
