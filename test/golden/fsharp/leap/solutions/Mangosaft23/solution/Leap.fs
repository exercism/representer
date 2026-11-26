module Leap


let leapYear (year: int): bool =
    match year % 4 with
    | 0 when (year%100<>0) -> true
    | 0 when (year%400=0) -> true
    | _ -> false