module Etl exposing (transform)

import Dict exposing (Dict)


etl : Int -> List String -> Dict String Int -> Dict String Int
etl score letters input =
    letters
        |> List.map String.toLower
        |> List.map (\l -> ( l, score ))
        |> Dict.fromList
        |> Dict.union input


transform : Dict Int (List String) -> Dict String Int
transform =
    Dict.foldr etl Dict.empty
