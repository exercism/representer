module Etl exposing (transform)

import Dict exposing (Dict, empty, insert, foldl)
import String exposing (toLower)

transform : Dict Int (List String) -> Dict String Int
transform =
    foldl 
        (\k cs a -> List.foldl (\c aa -> insert (toLower c) k aa) a cs)
        empty
