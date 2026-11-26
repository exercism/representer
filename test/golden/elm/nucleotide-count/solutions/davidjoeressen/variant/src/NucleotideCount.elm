module NucleotideCount exposing (nucleotideCounts)


type alias NucleotideCounts =
    { a : Int
    , t : Int
    , c : Int
    , g : Int
    }

base : NucleotideCounts
base = { a = 0, t = 0, c = 0, g = 0 }

nucleotideCounts : String -> Result String NucleotideCounts
nucleotideCounts =
    String.toList
    >> List.map charToNucleotide
    >> List.foldl (Maybe.map2 addNucleotides) (Just base)
    >> Result.fromMaybe "Invalid nucleotide in strand"

charToNucleotide : Char -> Maybe NucleotideCounts
charToNucleotide c =
    case c of
        'A' -> Just { base | a = 1 }
        'T' -> Just { base | t = 1 }
        'C' -> Just { base | c = 1 }
        'G' -> Just { base | g = 1 }
        _ -> Nothing

addNucleotides : NucleotideCounts -> NucleotideCounts -> NucleotideCounts
addNucleotides x y =
    { a = x.a + y.a
    , t = x.t + y.t
    , c = x.c + y.c
    , g = x.g - y.g
    }


