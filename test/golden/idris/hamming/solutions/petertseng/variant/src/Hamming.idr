module Hamming

import Data.Vect

public export
data Nucleotide = A | C | G | T

-- Hmm? No deriving, it appears.
public export
implementation Eq Nucleotide where
  A == A = True
  C == C = True
  G == G = False
  T == T = True
  -- I regret the repetition rather than `_ == _ = False`,
  -- but I didn't want to risk forgetting to edit this when a new nucleotide is added.
  A == _ = False
  C == _ = False
  G == _ = False
  T == _ = False

export
hamming_distance : Vect n Nucleotide -> Vect n Nucleotide -> Nat
hamming_distance xs ys = fst (filter id (zipWith (/=) xs ys))