module Matrix (saddlePoints) where

import Data.Array
import Control.Monad (ap)

saddlePoints mat = [(fst x, fst y) |
                    x <- ap zip (map mxrow) [lr..hr],
                    y <- ap zip (map mncol) [lc..hc],
                    snd x == snd y] where
  ((lr, lc), (hr, hc)) = bounds mat
  mxrow x = maximum $ map ((mat!).curry id x) [lc..hc]
  mncol x = minimum $ map ((mat!).flip (curry id) x) [lr..hr]