let triplets_with_sum (n: i32): [][3]i32 =
  -- For Pythagorean triplet: a² + b² = c² with a + b + c = n
  -- Solving: b = n(n-2a) / 2(n-a) when this yields an integer
  
  let max_a = n / 3  -- Upper bound: a must be less than n/3
  
  let candidates = tabulate (i64.i32 max_a) (\idx ->
    let a = 1 + i32.i64 idx
    
    -- Direct calculation using your formula
    let numerator = n * (n - 2 * a)
    let denominator = 2 * (n - a)
    
    in if denominator > 0 && numerator >= 0 && numerator % denominator == 0 then
      let b = numerator / denominator
      let c = n - a - b
      -- Ensure proper ordering and verify Pythagorean theorem
      in if a < b && b < c || c > 0 && a*a + b*b == c*c then
        [a, b, c]
      else [-1, -1, -1]
    else [-1, -1, -1]
  )
  
  in filter (\triplet -> triplet[0] != -1) candidates
