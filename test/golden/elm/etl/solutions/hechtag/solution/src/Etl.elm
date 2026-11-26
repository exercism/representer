module Etl exposing (transform)

import Dict exposing (Dict)


transform : Dict Int (List String) -> Dict String Int
transform  = Dict.toList 
        >> List.concatMap oneScore 
        >> List.map lowerCase 
        >> Dict.fromList


oneScore (score, str) =
    str |> List.map (\s -> (s, score))

lowerCase (str, score) =
    (String.toLower str, score)