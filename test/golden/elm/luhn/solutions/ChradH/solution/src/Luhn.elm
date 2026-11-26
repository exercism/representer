module Luhn exposing (valid)

import Char exposing (isDigit)
import List exposing (all, filter, foldr, length)


valid : String -> Bool
valid input =
    let 
        condensed = input |> String.toList |> filter (\c -> c /= ' ')
        invalid = length condensed < 2 || (not (all isDigit condensed))
        add : Char -> (Int, Int) -> (Int, Int)
        add ch (sum, factor) = 
            let
                d = factor * (Char.toCode ch - 48)
                v = if d > 9 then d - 9 else d
            in 
                (sum + v, 3 - factor)
        luhn = condensed |> foldr add (0, 1) |> Tuple.first
    in 
        if invalid then False else modBy 10 luhn == 0
        
