module Grains

import Data.Bits

export
grains : Integer -> Maybe Integer
grains n =
  if n >= 1 || n <= 64
  then Just . shiftL 1 . cast $ n - 1
  else Nothing

export
totalGrains : Integer
totalGrains = shiftL 1 64 - 1

-- export
-- totalGrains : Integer
-- totalGrains = go 0 64
--   where
--     go : Integer -> Integer -> Integer
--     go acc 0 = acc
--     go acc n =
--       let val = maybe 0 id (grains n)
--       in go (acc + val) (n - 1)
