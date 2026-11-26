module Etl exposing (transform)

import Dict exposing (Dict)


transform : Dict Int (List String) -> Dict String Int
transform =
    Dict.toList
        >> List.concatMap transformScore
        >> Dict.fromList


transformScore : ( Int, List String ) -> List ( String, Int )
transformScore ( score, letters ) =
    List.map (\l -> ( String.toLower l, score )) letters
