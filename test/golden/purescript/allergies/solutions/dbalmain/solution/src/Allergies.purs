module Allergies
  ( allergicTo
  , list
  ) where

import Data.Array (elemIndex, filter)
import Data.Int.Bits (shl, (.&.))
import Data.Maybe (fromMaybe)
import Prelude (bind, pure, ($), (<))

allergens ∷ Array String
allergens = [ "eggs"
            , "peanuts"
            , "shellfish"
            , "strawberries"
            , "tomatoes"
            , "chocolate"
            , "pollen"
            , "cats"]

allergicTo :: Int → String → Boolean
allergicTo n a = fromMaybe false $ do
    i ← elemIndex a allergens
    pure $ 0 < n .&. shl 1 i

list :: Int -> Array String
list n = filter (allergicTo n) allergens