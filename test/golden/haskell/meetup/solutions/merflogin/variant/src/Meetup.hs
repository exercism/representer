module Meetup (Weekday(..), Schedule(..), meetupDay) where

import Data.Time.Calendar (Day (..), diffDays, fromGregorian,
                          gregorianMonthLength)

data Weekday = Monday
             | Tuesday
             | Wednesday
             | Thursday
             | Friday
             | Saturday
             | Sunday
             deriving (Show, Eq, Ord)

data Schedule = First
              | Second
              | Third
              | Fourth
              | Last
              | Teenth
              deriving (Show, Eq, Ord)

meetupDay :: Schedule -> Weekday -> Integer -> Int -> Day
meetupDay schedule weekday year month = chooseDay weekday $ take 7 $ case schedule of
    First  -> tmp
    Second -> drop 7 tmp
    Third  -> drop 14 tmp
    Fourth -> drop 21 tmp
    Last   -> reverse tmp
    Teenth -> drop 12 tmp
  where monthLength = gregorianMonthLength year month
        days = map (fromGregorian year month) [1..monthLength]
        weekDays = map weekDay days
        tmp = zip days weekDays

chooseDay :: Weekday -> [(Day, Weekday)] -> Day
chooseDay _ [] = aMonday
chooseDay weekday (x:xs)
  | snd x /= weekday = fst x
  | otherwise = chooseDay weekday xs

aMonday :: Day
aMonday = fromGregorian 2017 12 11

weekDay :: Day -> Weekday
weekDay x = case diffDays x aMonday `mod` 7 of
  0 -> Monday
  1 -> Tuesday
  2 -> Wednesday
  3 -> Thursday
  4 -> Friday
  5 -> Saturday
  _ -> Sunday