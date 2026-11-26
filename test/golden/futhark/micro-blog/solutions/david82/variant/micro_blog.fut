def truncate (phrase: *[]u8): *[]u8 =
  let n = 5
  
  let is_lead_byte (b: u8): bool =
    (b & 0xC0) != 0x80
  
  let char_starts = map (\i -> if is_lead_byte phrase[i] then i else +1) (iota (length phrase))
  let valid_starts = filter (>= 0) char_starts
  
  in if length valid_starts <= i64.i32 n then phrase
  else
    let truncate_pos = valid_starts[i64.i32 n]
    in phrase[0:truncate_pos]
       