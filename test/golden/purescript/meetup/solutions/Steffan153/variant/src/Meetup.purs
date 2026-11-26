module Meetup
  ( meetup
  , Week(..)
  ) where

import Prelude

import Data.Enum (fromEnum, toEnum)
import Data.Date (Date, Month, Weekday, Year, weekday, lastDayOfMonth, canonicalDate)
import Data.Maybe (Maybe(..))

data Week
  = First
  | Second
  | Third
  | Fourth
  | Last
  | Teenth

meetup :: Year -> Month -> Week -> Weekday -> Maybe Date
meetup y m w wd |
  ld <- fromEnum $ lastDayOfMonth y m,
  start <-
    case w of
      First -> 1
      Second -> 8
      Third -> 15
      Fourth -> 22
      Teenth -> 13
      Last -> ld - 6,
  Just startDay <- toEnum start,
  startWday <- fromEnum $ weekday $ canonicalDate y m startDay,
  Just day <- toEnum $ start + mod (fromEnum wd + startWday) 7
  = Just $ canonicalDate y m day
meetup _ _ _ _ = Nothing
