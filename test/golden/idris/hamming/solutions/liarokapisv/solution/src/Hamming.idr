module Hamming

import Data.Vect

public export
data Nucleotide = A | C | T | G

implementation Eq Nucleotide where
  A == A = True
  C == C = True
  T == T = True
  G == G = True
  _ == _ = False

export total
hamming_distance : Vect n Nucleotide -> Vect n Nucleotide -> Nat
hamming_distance [] [] = 0
hamming_distance (x :: xs) (y :: ys) = (if x == y then 0 else 1) + hamming_distance xs ys