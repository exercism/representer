module Accumulate

export
-- I guess this exercise demonstrates the difficulty of types
-- this doesn't type-check.
-- The tests can't find an impl of Eq for the result of accumulate id []
-- The tests can't type (\x => x - 1)
accumulate : (a -> b) -> List a -> List b
accumulate f [] = []
accumulate f (x :: xs) = f x :: accumulate f xs