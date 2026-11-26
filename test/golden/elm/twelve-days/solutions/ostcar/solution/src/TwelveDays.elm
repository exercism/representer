module TwelveDays exposing (recite)


recite : Int -> Int -> List String
recite start stop =
    List.map dayToSong (List.range start stop)


dayToSong : Int -> String
dayToSong nr =
    "On the " ++ dayToString nr ++ " day of Christmas my true love gave to me: " ++ daySongList nr


dayToString : Int -> String
dayToString nr =
    case nr of
        1 ->
            "first"
        2 ->
            "second"
        3 ->
            "third"
        4 ->
            "fourth"
        5 ->
            "fifth"
        6 ->
            "sixth"
        7 ->
            "seventh"
        8 ->
            "eighth"
        9 ->
            "ninth"
        10 ->
            "tenth"
        11 ->
            "eleventh"
        12 ->
            "twelfth"
        _ ->
            ""

daySongList : Int -> String
daySongList nr =
    case nr of
        1 ->
            daySong 1
        _ ->
            (String.join ", " (List.map daySong (List.reverse (List.range 2 nr)))) ++ ", and " ++ daySong 1


daySong : Int -> String
daySong nr =
    case nr of
        1 ->
            "a Partridge in a Pear Tree."
        2 ->
            "two Turtle Doves"
        3 ->
            "three French Hens"
        4 ->
            "four Calling Birds"
        5 ->
            "five Gold Rings"
        6 ->
            "six Geese-a-Laying"
        7 ->
            "seven Swans-a-Swimming"
        8 ->
            "eight Maids-a-Milking"
        9 ->
            "nine Ladies Dancing"
        10 ->
            "ten Lords-a-Leaping"
        11 ->
            "eleven Pipers Piping"
        12 ->
            "twelve Drummers Drumming"
        _ ->
            ""
