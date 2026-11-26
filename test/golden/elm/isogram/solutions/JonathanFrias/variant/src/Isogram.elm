module Isogram exposing (isIsogram)

import Set


isIsogram : String -> Bool
isIsogram =
    String.toList
        >> List.map Char.toLower
        >> List.filter Char.isAlpha
        >> (\x -> uniqueLength x /= List.length x)


uniqueLength : List Char -> Int
uniqueLength =
    Set.fromList >> Set.toList >> List.length
