let distances2: [3]f64 = [ 1.0, 25.0, 100.0 ]
let scores: [3]i32 = [ 10, 5, 1 ]
def score (x: f64) (y: f64): i32 = let distance2: f64 = x * x + y * y in map (>= distance2) distances2 |> map i32.bool |> map2 (*) scores |> i32.maximum
