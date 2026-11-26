module Accumulate
  ( accumulate
  ) where

import Data.List (List(..), snoc, (:))

accumulate :: forall a b. (a -> b) -> List a -> List b
accumulate f xs = loop Nil f xs
  where
  loop :: forall c d. List d -> (c -> d) -> List c -> List d
  loop acc _ Nil = acc
  loop acc g (y:ys) = loop (snoc acc (g y)) g ys
