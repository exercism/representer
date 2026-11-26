module Etl exposing (transform, valuesToLower, transformList)

import Dict exposing (Dict)


valuesToLower : Dict Int (List String) -> Dict Int (List String)
valuesToLower input =
    Dict.map (\k v -> List.map String.toLower v ) input



transformList : List ( number, List String ) -> List (List ( String, number ))
transformList  input =
    List.map (\(x, y) -> List.map (\e -> (e, x)) y ) input



transform : Dict Int (List String) -> Dict String Int
transform input =
    valuesToLower input
        |> Dict.toList
        |> transformList
        |> List.concat
        |> Dict.fromList
