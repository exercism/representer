module Matrix (saddlePoints) where
import Data.Array (Array, assocs)
import Data.Ix (Ix)

saddlePoints :: (Ix a, Ord e) => Array (a, a) e -> [(a, a)]
saddlePoints matrix = [
    i
    | (i, e) <- assocs matrix
    , e == (maximum . dimension fst i) matrix
    , e == (minimum . dimension snd i) matrix
    ]

dimension :: Ix a => ((a, a) -> a) -> (a, a) -> Array (a, a) e -> [e]
dimension f i matrix = [ e | (j, e) <- assocs matrix, f i == f j ]
