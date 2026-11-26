module Meetup exposing (Month(..), Week(..), Weekday(..), meetup)


type Month
    = January
    | February
    | March
    | April
    | May
    | June
    | July
    | August
    | September
    | October
    | November
    | December


type Weekday
    = Monday
    | Tuesday
    | Wednesday
    | Thursday
    | Friday
    | Saturday
    | Sunday


type Week
    = First
    | Second
    | Third
    | Fourth
    | Last
    | Teenth


meetup : Int -> Month -> Week -> Weekday -> String
meetup year month week weekday =
    let
        firstDayOfMonth =
            daysUntil year month

        firstDayOfWeek =
            firstDayOfMonth
                + weekOffsetFor year month week

        firstWeekday =
            weekdayOf firstDayOfWeek

        dayOffset =
            (weekdayOffsetFor weekday + weekdayOffsetFor firstWeekday)
                |> modBy 7

        targetDate =
            firstDayOfWeek
                + dayOffset

        dayOfMonth =
            targetDate
                - firstDayOfMonth
    in
    formatDate year month dayOfMonth


weekdayOffsetFor : Weekday -> Int
weekdayOffsetFor weekday =
    case weekday of
        Monday ->
            0

        Tuesday ->
            1

        Wednesday ->
            2

        Thursday ->
            3

        Friday ->
            4

        Saturday ->
            5

        Sunday ->
            6


weekOffsetFor : Int -> Month -> Week -> Int
weekOffsetFor year month week =
    case week of
        First ->
            0

        Second ->
            7

        Third ->
            14

        Fourth ->
            21

        Last ->
            monthLength year month - 7

        Teenth ->
            12


weekdayOf : Int -> Weekday
weekdayOf day =
    case modBy 7 (day + epochWeekdayOffset) of
        0 ->
            Monday

        1 ->
            Tuesday

        2 ->
            Wednesday

        3 ->
            Thursday

        4 ->
            Friday

        5 ->
            Saturday

        6 ->
            Sunday

        _ ->
            Monday


epochWeekdayOffset : Int
epochWeekdayOffset =
    3


epochYear : Int
epochYear =
    1970


daysUntil : Int -> Month -> Int
daysUntil year month =
    List.range epochYear (year - 1)
        |> List.map yearLength
        |> List.sum
        |> (+) (daysUntilMonth year month)


monthLength : Int -> Month -> Int
monthLength year month =
    case month of
        January ->
            31

        February ->
            februaryOf year

        March ->
            31

        April ->
            30

        May ->
            31

        June ->
            30

        July ->
            31

        August ->
            31

        September ->
            30

        October ->
            31

        November ->
            30

        December ->
            31


daysUntilMonth : Int -> Month -> Int
daysUntilMonth year month =
    case month of
        January ->
            0

        February ->
            31

        March ->
            31 + februaryOf year

        April ->
            62 + februaryOf year

        May ->
            92 + februaryOf year

        June ->
            123 + februaryOf year

        July ->
            153 + februaryOf year

        August ->
            184 + februaryOf year

        September ->
            215 + februaryOf year

        October ->
            245 + februaryOf year

        November ->
            276 + februaryOf year

        December ->
            306 + februaryOf year


yearLength : Int -> Int
yearLength =
    februaryOf >> (+) 337


februaryOf : Int -> Int
februaryOf year =
    case [ 400, 100, 4 ] |> List.map (\n -> modBy n year) of
        [ 0, _, _ ] ->
            29

        [ _, 0, _ ] ->
            28

        [ _, _, 0 ] ->
            29

        _ ->
            28



-- FORMATTING


formatDate : Int -> Month -> Int -> String
formatDate year month day =
    [ formatYear year, formatMonth month, formatDay day ]
        |> String.join "-"


formatYear : Int -> String
formatYear =
    String.fromInt


formatMonth : Month -> String
formatMonth month =
    case month of
        January ->
            "01"

        February ->
            "02"

        March ->
            "03"

        April ->
            "04"

        May ->
            "05"

        June ->
            "06"

        July ->
            "07"

        August ->
            "08"

        September ->
            "09"

        October ->
            "10"

        November ->
            "11"

        December ->
            "12"


formatDay : Int -> String
formatDay =
    (+) 1 >> String.fromInt >> String.padLeft 2 '0'
