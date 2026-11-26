module Etl exposing (transform)

import Dict exposing (Dict)


transform : Dict Int (List String) -> Dict String Int
transform input =
    input
    |> Dict.toList
    |> List.concatMap (\(x,ys)-> List.map (\y -> (String.toLower y, x)) ys)
    |> Dict.fromList

