module Grains exposing (square)


square : Int -> Maybe Int
square n =
    let
        sq =
            2 ^ (n + 1)
    in
    if sq >= 1 then
        Just sq

    else
        Nothing
