module ETL (transform) where

import qualified Data.Char as Char
import Data.Map (Map)
import qualified Data.Map.Strict as Map

transform :: Map a String -> Map Char a
transform =
  Map.foldrWithKey f Map.empty
  where
    f k str m =
      foldr (\ch -> Map.insert (Char.toLower ch) k) m str
