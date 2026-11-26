module Etl exposing (transform)

import Dict exposing (Dict)


transform : Dict Int (List String) -> Dict String Int
transform input =
    input
    |> Dict.toList
    |> List.concatMap tr
    |> Dict.fromList

tr : (Int, List String) -> List (String, Int)
tr (sc, letters) =
    case letters of 
        [] -> []
        head::tail -> (String.toLower head, sc) :: tr (sc, tail)

