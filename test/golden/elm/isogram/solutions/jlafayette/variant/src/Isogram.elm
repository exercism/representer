module Isogram exposing (isIsogram)

import Set


isIsogram : String -> Bool
isIsogram sentence =
    let
        justLetters =
            sentence
                |> String.toUpper
                |> String.toList
                |> List.filter Char.isLower

        len =
            List.length justLetters
    in
    justLetters
        |> Set.fromList
        |> Set.size
        |> (==) len
