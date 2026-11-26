module Etl exposing (transform)

import Dict exposing (Dict)
import String exposing (toLower)

transform : Dict Int (List String) -> Dict String Int
transform input =
    Dict.foldl (\key value acc ->
        List.foldl (\letter acc2->
            Dict.insert (toLower letter) key acc2
        ) acc value
    ) Dict.empty input
