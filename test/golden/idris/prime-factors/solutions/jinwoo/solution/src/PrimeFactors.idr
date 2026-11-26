module PrimeFactors

export
factors : Int -> List Int
factors value = go [] value 2
  where
    go : List Int -> Int -> Int -> List Int
    go acc value divisor =
      if divisor > value then
        reverse acc
      else if value `mod` divisor == 0 then
        go (divisor :: acc) (value `div` divisor) divisor
      else
        go acc value (divisor + 1)
