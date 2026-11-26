module Etl exposing (transform)

import Dict exposing (Dict, foldl, fromList, union)
import List exposing (map)
import String exposing (toLower)


transform : Dict Int (List String) -> Dict String Int
transform input =
    foldl etl Dict.empty input


etl : Int -> List String -> Dict String Int -> Dict String Int
etl score letters acc =
    union acc <|
        fromList <|
            buildLetterToScoreTuples score letters


buildLetterToScoreTuples : Int -> List String -> List ( String, Int )
buildLetterToScoreTuples score letters =
    map (\letter -> ( toLower letter, score )) letters
