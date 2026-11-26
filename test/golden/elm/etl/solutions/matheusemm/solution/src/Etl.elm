module Etl exposing (transform)

import Dict exposing (Dict)


transform : Dict Int (List String) -> Dict String Int
transform input =
    input
        |> Dict.map (\_ letters -> List.map String.toLower letters)
        |> Dict.toList
        |> List.concatMap
            (\( point, letters ) ->
                List.map (\l -> ( l, point )) letters
            )
        |> Dict.fromList
