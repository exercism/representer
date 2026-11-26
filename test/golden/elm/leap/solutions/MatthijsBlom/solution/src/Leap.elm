module Leap exposing (isLeapYear)


isLeapYear : Int -> Bool
isLeapYear year =
    let
        divisibleBy d =
            modBy d year == 0
    in
    divisibleBy 4 && (not (divisibleBy 100) || divisibleBy 400)
