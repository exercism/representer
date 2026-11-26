def log2 (x: i32): i32 = f64.i32 x |> f64.log2 |> i32.f64

def bit_list (x: i32) = map (\b -> i32.get_bit b x) (0...log2 x)

def egg_count (encoded_value: i32): i32 = bit_list encoded_value |> i32.sum
