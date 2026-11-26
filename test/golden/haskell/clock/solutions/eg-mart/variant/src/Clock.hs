module Clock (addDelta, fromHourMin, toString) where

data Clock = Clock { hours :: Int, minutes :: Int }
  deriving Eq

fromHourMin :: Int -> Int -> Clock
fromHourMin hour min = Clock ((hour - min `div` 60) `mod` 24) (min `mod` 60)

pad :: Int -> Char -> String -> String
pad n x xs = replicate (n - length xs) x ++ xs

toString :: Clock -> String
toString clock = (pad 2 '0' . show . hours $ clock) ++ ":" ++ (pad 2 '0' . show . minutes $ clock)

addDelta :: Int -> Int -> Clock -> Clock
addDelta hour min clock = Clock ((h + hour + (m + min) `div` 60) `mod` 24) ((m + min) `mod` 60)
  where
    h = hours clock
    m = minutes clock
