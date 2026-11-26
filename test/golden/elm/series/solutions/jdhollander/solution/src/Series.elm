module Series exposing (slices)

import Char
import String
import List

slices : Int -> String -> Result String (List (List Int))
slices size input =
    let
        numbers = String.toList input
            |> List.map (String.fromChar >> String.toInt)
            |> List.filter (\m -> m /= Nothing)
            |> List.map (\m ->
                case m of
                    Nothing -> 0
                    Just x -> x
            )
        length = List.length numbers
    in
        if length == 0 then
            Err "series cannot be empty"
        else if size > length then
            Err "slice length cannot be greater than series length"
        else if size == 0 then
            Err "slice length cannot be zero"
        else if size < 0 then
            Err "slice length cannot be negative"
        else
            List.range 0 (length - size)
            |> List.map (\i -> List.take size (List.drop i numbers))
            |> Ok