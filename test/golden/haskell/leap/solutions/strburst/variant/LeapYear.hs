module LeapYear (
    isLeapYear
) where

isLeapYear :: Integer -> Bool
isLeapYear year = year `divisibleBy` 400 && (not $ year `divisibleBy` 100)
                    && year `divisibleBy` 4

divisibleBy :: (Integral a) => a -> a -> Bool
divisibleBy a b = (a `mod` b) == 0