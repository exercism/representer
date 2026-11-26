module Series exposing (slices)

import List
import Array
import String exposing (String(..))

slices : Int -> String -> Result String (List (List Int))
slices size input =
    if String.length input == 0 then
        Err "series cannot be empty"
    else if size < 0 then
        Err "slice length cannot be negative"
    else if size == 0 then
        Err "slice length cannot be zero"
    else if size > String.length input then
        Err "slice length cannot be greater than series length"
    else
        let
            slice : Int -> List Int -> List (List Int) -> Result String (List (List Int))
            slice x xs acc =  
                case xs of 
                    [] -> Ok acc
                    _ -> if (List.length xs) >= x then
                            slice x (List.drop 1 xs) ( acc ++ [(Array.toList <| Array.slice 0 x <| Array.fromList xs)])
                        else
                            Ok acc
        in
            slice size (List.filterMap String.toInt (List.map String.fromChar (String.toList input))) []