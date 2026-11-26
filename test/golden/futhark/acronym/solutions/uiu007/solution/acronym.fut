def is_letter (c: u8): bool =
  (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z')

def to_upper (c: u8): u8 =
  if c >= 'a' && c <= 'z' then c - 32 else c

def is_acronym_char (phrase: []u8)(i: i32): bool =
    let c = phrase[i] in
      if !is_letter c then false
      else if i == 0 then true
      else 
        let prev = phrase[i-1]
        in prev == ' ' || prev == '-'

def abbreviate (phrase: []u8): []u8 =
  let n = length phrase
  in iota n
     |> map i32.i64
     |> filter (is_acronym_char phrase)
     |> map (\i -> to_upper phrase[i])