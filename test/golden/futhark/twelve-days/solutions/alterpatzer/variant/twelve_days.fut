def goodies: []u8 = "twelve Drummers Drumming, eleven Pipers Piping, ten Lords-a-Leaping, nine Ladies Dancing, eight Maids-a-Milking, seven Swans-a-Swimming, six Geese-a-Laying, five Gold Rings, four Calling Birds, three French Hens, two Turtle Doves, and a Partridge in a Pear Tree.\n"

def ordinal: []u8 = "zeroth, first, second, third, fourth, fifth, sixth, seventh, eighth, ninth, tenth, eleventh, twelfth"

def commas (text: []u8): []i64 =
  filter (\i -> text[i] == ',') (iota (length text))

def trailing (text: []u8) (cut: i64): []u8 =
  let x = if cut == 0 then 0 else 2 - (commas text)[cut - 1]
  in text[x:]

def word (text: []u8) (w: i64): []u8 =
  let cs = commas text
  let start = if w == 0 then 0 else cs[w - 1] + 2
  let stop = if w == length cs then length text else cs[w]
  in text[start:stop]

def verse (day: i32): []u8 =
  let cut = i64.i32 (12 - day)
  let g = trailing goodies cut
  let gifts = if day == 1 then drop 4 g else g
  let which = word ordinal (i64.i32 day)
  in
    "On the " ++ which ++ " day of Christmas my true love gave to me: " ++ gifts

def recite (start_verse: i32) (end_verse: i32): []u8 =
  loop poem = "" for i < end_verse - start_verse + 1 do
     poem ++ verse (start_verse + i)
