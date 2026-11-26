module PerfectNumbers

public export
data Category = Perfect | Abundant | Deficient

aliquotSum : Int -> Int
aliquotSum n = if n == 1 then 0 else go 1 2
  where
    go : Int -> Int -> Int
    go acc divisor =
      if divisor * divisor > n
         then acc
         else if n `mod` divisor == 0
                 then let q := n `div` divisor in
                      if q == divisor then go (acc + divisor) (divisor + 1)
                                      else go (acc + divisor + q) (divisor + 1)
                 else go acc (divisor + 1)

export
classify : Int -> Maybe Category
classify number =
  if number <= 0
     then Nothing
     else Just $
       case compare number (aliquotSum number) of
         EQ => Perfect
         LT => Abundant
         GT => Deficient
