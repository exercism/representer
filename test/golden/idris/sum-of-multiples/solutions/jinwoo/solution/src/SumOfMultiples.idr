module SumOfMultiples

export
sum : List Int -> Int -> Int
sum factors limit =
  foldl (\acc, n =>
          if any (\factor => factor /= 0 && n `mod` factor == 0) factors
             then acc + n
             else acc)
        0 [1 .. limit - 1]
