module Meetup (Weekday(..), Schedule(..), meetupDay) where

import Data.Time.Calendar (Day, addDays, fromGregorian, gregorianMonthLength)

import Data.Time.Calendar.WeekDate (toWeekDate)

data Weekday = Monday
             | Tuesday
             | Wednesday
             | Thursday
             | Friday
             | Saturday
             | Sunday
data Schedule = First
              | Second
              | Third
              | Fourth
              | Last
              | Teenth

meetupDay :: Schedule -> Weekday -> Integer -> Int -> Day
meetupDay schedule weekday year month = addDays (toInteger daysMove) startDay
  where startDay = fromGregorian year month (dayOffset schedule year month)
        (_, _, startWeekday) = toWeekDate startDay
        daysMove = mod (7 + (weekdayIdx weekday) - startWeekday) 7

weekdayIdx :: Weekday -> Int
weekdayIdx Monday = 1
weekdayIdx Tuesday = 2
weekdayIdx Wednesday = 3
weekdayIdx Thursday = 4
weekdayIdx Friday = 5
weekdayIdx Saturday = 6
weekdayIdx Sunday = 7

dayOffset :: Schedule -> Integer -> Int -> Int
dayOffset First _ _ = 1
dayOffset Second _ _ = 8
dayOffset Third _ _ = 15
dayOffset Fourth _ _ = 22
dayOffset Last year month = (gregorianMonthLength year month) - 6
dayOffset Teenth _ _ = 13