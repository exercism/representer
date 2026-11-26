module Hamming

import Data.Vect

public export
data Nucleotide = A
                | G
                | C
                | T

export
hamming_distance : Vect n Nucleotide -> Vect n Nucleotide -> Nat
hamming_distance [] [] = 0
hamming_distance (x :: xs) (y :: ys) = (distanceOf (x, y)) +
                                       (hamming_distance xs ys)
  where
    distanceOf : (Nucleotide, Nucleotide) -> Nat
    distanceOf (A, A) = 0
    distanceOf (G, G) = 0
    distanceOf (C, C) = 0
    distanceOf (T, T) = 0
    distanceOf _ = 1