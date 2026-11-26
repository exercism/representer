module Accumulate

export
accumulate : (a -> b) -> List a -> List b
accumulate _ [] = []
accumulate f (x :: xs) = f x :: accumulate f xs