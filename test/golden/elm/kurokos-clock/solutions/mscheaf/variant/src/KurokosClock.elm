module KurokosClock exposing (Locale(..), showDateTime, showLocalDate, showLocalTime)

import Time exposing (Month(..), Posix, Zone)


type Locale
    = US
    | JP


monthToInt : Month -> Int
monthToInt month =
    case month of
        Jan ->
            1
        Feb ->
            2
        Mar ->
            3
        Apr ->
            4
        May ->
            5
        Jun ->
            6
        Jul ->
            7
        Aug ->
            8
        Sep ->
            9
        Oct ->
            10
        Nov ->
            11
        Dec ->
            12


showLocalDate : Locale -> Int -> Month -> Int -> String
showLocalDate locale year month day =
    case locale of
        US ->
            String.fromInt (monthToInt month) ++ "/" ++ String.fromInt day ++ "/" ++ String.fromInt year

        JP ->
            String.fromInt year ++ "年" ++ String.fromInt (monthToInt month) ++ "月" ++ String.fromInt day ++ "日"


showLocalTime : Locale -> Int -> Int -> String
showLocalTime locale hour minute =
    let
        afternoon =
            hour >= 12
            
        amPm =
            if hour >= 12 then
                " PM"
            else
                " AM"

        format12Hour =
            if afternoon then
                (modBy 12 hour)
            else
                if hour == 0 then 12 else hour
    in
    case locale of
        US ->
            String.fromInt format12Hour ++ ":" ++ String.padLeft 2 '0' (String.fromInt minute) ++ amPm

        JP ->
            String.fromInt hour ++ "時" ++ String.fromInt minute ++ "分"


showDateTime : Locale -> Zone -> Posix -> String
showDateTime locale zone posix =
    let
        year =
            Time.toYear zone posix
            
        month =
            Time.toMonth zone posix
        
        day =
            Time.toDay zone posix
            
        hour =
            Time.toHour zone posix
        
        minute =
            Time.toMinute zone posix

        whiteSpace =
            case locale of
                US ->
                    " "
                JP ->
                    ""
    in
        showLocalDate locale year month day ++ whiteSpace ++ showLocalTime locale hour minute

