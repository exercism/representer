def add_parity (x: i32): i32 =
  2 * x + (i32.popc x % 2)

def split_word (x: i32) (bits: i32): (i32, i32) =
  let start = x >> (8 - bits)
  let rest = (x & ((1 << (8 - bits)) - 1)) << (bits - 1)
  in (start, rest)

def transmit_sequence (message: []i32): []i32 =
  let (code, carried, bits) =
    loop (code, carried, bits) =
    ([], 0, 7)
    for x in message do
       let (use, keep) = split_word x bits
       let y = add_parity (carried | use)
       in
           if bits != 1
           then (code ++ [y], keep, bits - 1)
           else
              let y2 = add_parity (x & 0x7f)
              in (code ++ [y, y2], 0, 7)
   in
     if bits == 7
     then code ++ [add_parity carried]
     else code

def decode_message (message: []i32): []i32 =
   let (text, _, _) =
     loop(text, carried, bits) =
     ([], 0, 8)
     for x in message do
       let y = assert (i32.popc x % 2 == 0) (x / 2)
       in
         if bits == 8
         then (text, 2 * y, 1)
         else
           let (use, keep) = split_word y (bits + 1)
           in
              (text ++ [carried|use], 2 * keep, bits + 1)
    in
      text
