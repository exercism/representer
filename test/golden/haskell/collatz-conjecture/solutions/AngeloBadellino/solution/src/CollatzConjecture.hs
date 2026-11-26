module CollatzConjecture (collatz) where

collatz :: Integer -> Maybe Integer
collatz i
    | i <= 0 = Nothing
    | i == 1 = Just 0
    | even i = succ <$> collatz (i `div` 2)
    | otherwise = succ <$> collatz (3 * i + 1)