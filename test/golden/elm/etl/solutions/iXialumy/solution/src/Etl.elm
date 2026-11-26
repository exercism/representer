module Etl exposing (transform)

import Dict exposing (Dict)


transform : Dict Int (List String) -> Dict String Int
transform input =
    input
        |> Dict.toList
        |> flipDicts
        |> List.map Dict.toList
        |> List.concat
        |> List.map (\( a, b ) -> expandList a b)
        |> List.concat
        |> tupleListToUpper
        |> Dict.fromList


expandList : List a -> b -> List ( a, b )
expandList list n =
    List.map (\m -> Tuple.pair m n) list


flipDicts =
    List.map (\( a, b ) -> Dict.singleton b a)


tupleListToUpper =
    List.map (\( a, b ) -> Tuple.pair (String.toLower a) b)
