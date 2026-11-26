let lower_word (n: i32): []u8 =
  match n
  case 0 -> "no"
  case 1 -> "one"
  case 2 -> "two"
  case 3 -> "three"
  case 4 -> "four"
  case 5 -> "five"
  case 6 -> "six"
  case 7 -> "seven"
  case 8 -> "eight"
  case 9 -> "nine"
  case _ -> "ten"

let title_word (n: i32): []u8 =
  match n
  case 0 -> "No"
  case 1 -> "One"
  case 2 -> "Two"
  case 3 -> "Three"
  case 4 -> "Four"
  case 5 -> "Five"
  case 6 -> "Six"
  case 7 -> "Seven"
  case 8 -> "Eight"
  case 9 -> "Nine"
  case _ -> "Ten"

let bottle_word (n: i32): []u8 =
  match n
  case 1 -> "bottle"
  case _ -> "bottles"

let verse (n: i32): []u8 =
  let line1 =
    title_word n ++ " green " ++ bottle_word n ++ " hanging on the wall,\n"
  let line3 =
    "And if one green bottle should accidentally fall,\n"
  let next_n = n - 1
  let line4 =
    "There'll be " ++ lower_word next_n ++ " green " ++ bottle_word next_n
    ++ " hanging on the wall.\n"
  in line1 ++ line1 ++ line3 ++ line4

def recite (start_bottles: i32) (take_down: i32): []u8 =
  loop acc = "" for i <= take_down do
    let n = start_bottles - i
    let sep = match i
              case 0 -> ""
              case _ -> "\n"
    in acc ++ sep ++ verse n
