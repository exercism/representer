module Etl exposing (transform)

import Dict exposing (Dict)


transform : Dict Int (List String) -> Dict String Int
transform input =
  Dict.toList input 
  |> List.concatMap valsToKeys
  |> Dict.fromList


valsToKeys : (Int, List String) -> List (String,Int)
valsToKeys (k, vals) =
  List.map (\val -> (String.toLower val,k)) vals

