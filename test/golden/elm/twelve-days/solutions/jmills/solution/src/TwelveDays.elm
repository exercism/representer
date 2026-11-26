module TwelveDays exposing (recite)

import Dict exposing (Dict)


recite : Int -> Int -> List String
recite start stop =
    List.range start stop
        |> List.map stanza


stanza : Int -> String
stanza day =
    "On the "
        ++ ordinal day
        ++ " day of Christmas my true love gave to me: "
        ++ listGifts day


ordinal : Int -> String
ordinal n =
    let
        ord : Dict Int String
        ord =
            Dict.fromList
                [ ( 0, "zeroth" )
                , ( 1, "first" )
                , ( 2, "second" )
                , ( 3, "third" )
                , ( 4, "fourth" )
                , ( 5, "fifth" )
                , ( 6, "sixth" )
                , ( 7, "seventh" )
                , ( 8, "eighth" )
                , ( 9, "ninth" )
                , ( 10, "tenth" )
                , ( 11, "eleventh" )
                , ( 12, "twelfth" )
                ]
    in
    case Dict.get n ord of
        Just str ->
            str

        Nothing ->
            case modBy 10 n of
                1 ->
                    String.fromInt n ++ "st"

                2 ->
                    String.fromInt n ++ "nd"

                3 ->
                    String.fromInt n ++ "rd"

                _ ->
                    String.fromInt n ++ "th"


listGifts : Int -> String
listGifts day =
    List.range 1 day
        |> List.reverse
        |> List.map (\a -> Dict.get a gifts)
        |> List.map (Maybe.withDefault "")
        |> String.join ""


gifts : Dict Int String
gifts =
    Dict.fromList
        [ ( 1, "a Partridge in a Pear Tree." )
        , ( 2, "two Turtle Doves, and " )
        , ( 3, "three French Hens, " )
        , ( 4, "four Calling Birds, " )
        , ( 5, "five Gold Rings, " )
        , ( 6, "six Geese-a-Laying, " )
        , ( 7, "seven Swans-a-Swimming, " )
        , ( 8, "eight Maids-a-Milking, " )
        , ( 9, "nine Ladies Dancing, " )
        , ( 10, "ten Lords-a-Leaping, " )
        , ( 11, "eleven Pipers Piping, " )
        , ( 12, "twelve Drummers Drumming, " )
        ]
