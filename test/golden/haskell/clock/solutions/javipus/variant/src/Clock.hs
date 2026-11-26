module Clock (addDelta, fromHourMin, toString) where

data Clock = Clock {hours :: Int, mins :: Int}
  deriving Eq

fromHourMin :: Int -> Int -> Clock
fromHourMin h m = Clock ((h + m `div` 60) `mod` 24) (m `mod` 60)

toString :: Clock -> String
toString clock = disp (hours clock) ++ ":" ++ disp (mins clock) where
  disp n
    | n < 10 = "0" ++ show n
    | otherwise = show n

addDelta :: Int -> Int -> Clock -> Clock
addDelta h m clock = fromHourMin h' m' where
  h' = (h - hours clock + (m + mins clock) `div` 60) `mod` 24
  m' = (m + mins clock) `mod` 60
