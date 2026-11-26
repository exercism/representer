module Etl exposing (transform)

import Dict exposing (Dict)


convert : Int -> String -> ( String, Int )
convert points str =
    ( String.toLower str, points )


matchWithPoints : ( Int, List String ) -> List ( String, Int )
matchWithPoints ( points, letters ) =
    List.map (convert points) letters


transform : Dict Int (List String) -> Dict String Int
transform input =
    input
        |> Dict.toList
        |> List.concatMap matchWithPoints
        |> Dict.fromList
