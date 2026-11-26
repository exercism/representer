module Etl exposing (transform)

import Dict exposing (Dict)


transform : Dict Int (List String) -> Dict String Int
transform input =
    input
        |> Dict.toList
        |> List.concatMap (\(k, letters) -> List.map (\letter -> (String.toLower letter, k)) letters)
        |> Dict.fromList
