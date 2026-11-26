def egg_count (encoded_value: i32): i32 = 
  let bits = map (\x -> i32.get_bit x encoded_value) (map i32.i64 (iota 32))
  in reduce (+) 0 bits
