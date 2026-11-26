module RnaTranscription

import Data.Vect

%default total

namespace DnaNucleotide
  public export
  data DnaNucleotide = A | C | G | T

namespace RnaNucleotide
  public export
  data RnaNucleotide = A | C | G | U

export
implementation Eq RnaNucleotide where
  A == A = True
  C == C = True
  G == G = True
  U == U = True
  _ == _ = False

export
implementation Show RnaNucleotide where
  show A = "A"
  show C = "C"
  show G = "G"
  show U = "U"

export
toRna : Vect n DnaNucleotide -> Vect n RnaNucleotide
toRna = map (\n => case n of
                        G => C
                        C => G
                        T => A
                        A => U)
