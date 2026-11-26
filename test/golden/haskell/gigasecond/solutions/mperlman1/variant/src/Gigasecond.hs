module Gigasecond (fromDay) where

import           Data.Time.Clock (UTCTime, addUTCTime)

fromDay :: UTCTime -> UTCTime
fromDay birthday = (10 ^ 10) `addUTCTime` birthday