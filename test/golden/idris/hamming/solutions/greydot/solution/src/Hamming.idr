module Hamming

import Data.Vect

public export
data Nucleotide = A | T | C | G

Eq Nucleotide where
  A == A = True
  T == T = True
  C == C = True
  G == G = True
  _ == _ = False

export
hamming_distance : Vect n Nucleotide -> Vect n Nucleotide -> Nat
hamming_distance s1 s2 = go s1 s2 0
  where
    go : Vect n' Nucleotide -> Vect n' Nucleotide -> Nat -> Nat
    go [] [] d = d
    go (n1 :: ns1) (n2 :: ns2) d = go ns1 ns2 (if n1 == n2 then d else d + 1)