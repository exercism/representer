module ScrabbleScore exposing (scoreWord)


scoreWord : String -> Int
scoreWord x =
    x
        |> String.toLower
        |> String.toList
        |> List.map scoreLetter
        |> List.sum


scoreLetter : Char -> Int
scoreLetter c =
    case c of
        'b' ->
            3

        'c' ->
            3

        'd' ->
            2

        'f' ->
            4

        'g' ->
            2

        'h' ->
            4

        'j' ->
            8

        'k' ->
            5

        'm' ->
            3

        'p' ->
            3

        'q' ->
            10

        'v' ->
            4

        'w' ->
            5

        'x' ->
            8

        'y' ->
            4

        'z' ->
            10

        'a' ->
            1

        'e' ->
            1

        'i' ->
            1

        'o' ->
            1

        'u' ->
            1

        'l' ->
            1

        'n' ->
            1

        'r' ->
            1

        's' ->
            1

        't' ->
            1

        _ ->
            0
