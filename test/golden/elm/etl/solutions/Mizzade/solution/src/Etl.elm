module Etl exposing (transform)

import Dict exposing (Dict)


transform : Dict Int (List String) -> Dict String Int
transform input =
    Dict.foldl createValueKeyDict Dict.empty input


createValueKeyDict : Int -> (List String) -> Dict String Int -> Dict String Int
createValueKeyDict value letters target =
    List.map String.toLower letters
        |> List.map (createValueKeyTuple value)
        |> Dict.fromList
        |> Dict.union target

createValueKeyTuple : Int -> String -> (String, Int)
createValueKeyTuple value key = 
    (key, value)
    