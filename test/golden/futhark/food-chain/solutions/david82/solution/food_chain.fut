-- Global string constants
def opening_prefix: []u8 = "I know an old lady who swallowed a "
def horse_ending: []u8 = "She's dead, of course!\n"
def fly_ending: []u8 = "I don't know why she swallowed the fly. Perhaps she'll die.\n"
def chain_prefix: []u8 = "She swallowed the "
def chain_middle: []u8 = " to catch the "
def spider_suffix: []u8 = " that wriggled and jiggled and tickled inside her"

def data (i: i32): ([]u8, []u8) = match i
  case 0 -> ("fly", copy fly_ending)
  case 1 -> ("spider", "It wriggled and jiggled and tickled inside her.")
  case 2 -> ("bird", "How absurd to swallow a bird!")
  case 3 -> ("cat", "Imagine that, to swallow a cat!")
  case 4 -> ("dog", "What a hog, to swallow a dog!")
  case 5 -> ("goat", "Just opened her throat and swallowed a goat!")
  case 6 -> ("cow", "I don't know how she swallowed a cow!")
  case _ -> ("horse", copy horse_ending)

def verse (n: i32): []u8 =
  let (animal, reaction) = data (n - 1)
  let opening = copy opening_prefix ++ animal ++ ".\n"
  in match n
  case 8 -> opening ++ copy horse_ending
  case 1 -> opening ++ copy fly_ending
  case _ ->
    let (chain, _) = loop (acc, i) = ("", n - 1) while i > 0 do
      let (pred, _) = data i
      let (prey, _) = data (i-1)
      let line = copy chain_prefix ++ pred ++ copy chain_middle ++ prey ++ 
                 (if i-1 == 1 then copy spider_suffix else "") ++ ".\n"
      in (acc ++ line, i - 1)
    in opening ++ reaction ++ "\n" ++ chain ++ copy fly_ending

def recite (start: i32) (end: i32): []u8 =
  if start == end then verse start
  else
    let (result, _) = loop (acc, i) = (verse start, start + 1) while i <= end do
      (acc ++ "\n" ++ verse i, i + 1)
    in result
           