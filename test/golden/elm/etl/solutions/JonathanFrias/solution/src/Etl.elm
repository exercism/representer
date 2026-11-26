module Etl exposing (transform)

import Dict exposing (Dict)


transform : Dict Int (List String) -> Dict String Int
transform dict =
    Dict.fromList <| List.concat <| List.map (doWork dict) (Dict.keys dict)


doWork dict key =
    case Dict.get key dict of
        Just list ->
            list |> List.map (\x -> ( String.toLower x, key ))

        _ ->
            []
