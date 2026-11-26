module Leap exposing (isLeapYear)


isDivisible : Int -> Int -> Bool
isDivisible number divisor = 
    (modBy divisor number) == 0

isLeapYear : Int -> Bool
isLeapYear year =
    if isDivisible year 400 then True
    else if isDivisible year 100 then False
    else if isDivisible year 4 then True
    else False
