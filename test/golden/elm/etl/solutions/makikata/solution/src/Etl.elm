module Etl exposing (transform)

import Dict exposing (Dict)


transform : Dict Int (List String) -> Dict String Int
transform input =
    Dict.foldl
        (\score letters default ->
            List.foldl (\x dict -> Dict.insert (String.toLower x) score dict) default letters
        )
        Dict.empty
        input
