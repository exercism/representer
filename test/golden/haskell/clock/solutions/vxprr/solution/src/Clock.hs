module Clock (addDelta, fromHourMin, toString) where
import Text.Printf
data Clock = Clock { dayMins :: Int } deriving Eq
fromHourMin :: Int -> Int -> Clock
fromHourMin h m = Clock $ (60*h + m) `mod` (60*24)
toString :: Clock -> String
toString (Clock {dayMins=dm}) = printf "%02d:%02d" (dm `div` 60) (dm `mod` 60)
addDelta :: Int -> Int -> Clock -> Clock
addDelta h m (Clock {dayMins=dm}) = Clock $ (dm + 60*h + m) `mod` (60*24)