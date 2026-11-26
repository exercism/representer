-- Build the subject for position i (0-based) using optimized pattern matching
let get_subject (i: i32): []u8 =
  match i
  case 0  -> "house that Jack built."
  case 1  -> "malt"
  case 2  -> "rat"
  case 3  -> "cat"
  case 4  -> "dog"
  case 5  -> "cow with the crumpled horn"
  case 6  -> "maiden all forlorn"
  case 7  -> "man all tattered and torn"
  case 8  -> "priest all shaven and shorn"
  case 9  -> "rooster that crowed in the morn"
  case 10 -> "farmer sowing his corn"
  case 11 -> "horse and the hound and the horn"
  case _  -> ""

-- Get the bridge/relation for position i (1-based indexing for bridges)
let get_bridge (i: i32): []u8 =
  match i
  case 1  -> " that lay in "
  case 2  -> " that ate "
  case 3  -> " that killed "
  case 4  -> " that worried "
  case 5  -> " that tossed "
  case 6  -> " that milked "
  case 7  -> " that kissed "
  case 8  -> " that married "
  case 9  -> " that woke "
  case 10 -> " that kept "
  case 11 -> " that belonged to "
  case _  -> ""

-- Build a single verse using functional programming approach
let build_verse (verse_num: i32): []u8 =
  let start_text = "This is the " ++ get_subject (verse_num - 1)
  in if verse_num == 1
     then start_text ++ "\n"
     else
       -- Build chain by folding over the sequence from verse_num-1 down to 1
       let chain_length = verse_num - 1
       let result = 
         loop acc = start_text for step_idx < chain_length do
           let current_bridge_idx = chain_length - step_idx
           let bridge_text = get_bridge current_bridge_idx
           let subject_text = get_subject (current_bridge_idx - 1)
           in acc ++ bridge_text ++ "the " ++ subject_text
       in result ++ "\n"

-- Public API: Generate verses from start_verse to end_verse (inclusive)
def recite (start_verse: i32) (end_verse: i32): []u8 =
  -- Input validation and bounds checking
  let max_verses = 12
  let valid_start = i32.max 1 start_verse
  let valid_end = i32.min max_verses (i32.max start_verse end_verse)
  let verse_count = valid_end - valid_start + 1
  
  -- Generate all requested verses using functional approach
  in if verse_count <= 0
     then ""
     else
       loop result = "" for verse_offset < verse_count do
         result ++ build_verse (valid_start + verse_offset)
  