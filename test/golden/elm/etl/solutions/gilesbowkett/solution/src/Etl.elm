module Etl exposing (transform)

import Dict exposing (Dict)


transform : Dict Int (List String) -> Dict String Int
transform input =
    Dict.fromList
        (List.concat
            (List.map
                (\( points, letters ) ->
                    List.map (\x -> ( (String.toLower x), points )) letters
                )
                (Dict.toList input)
            )
        )
