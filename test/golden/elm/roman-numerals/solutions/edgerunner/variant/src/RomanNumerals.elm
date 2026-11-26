module RomanNumerals exposing (toRoman)


type Numeral
    = Numeral String Int


descendingNumerals : List Numeral
descendingNumerals =
    [ Numeral "M" 1000
    , Numeral "CM" 900
    , Numeral "D" 500
    , Numeral "CD" 400
    , Numeral "C" 100
    , Numeral "XC" 90
    , Numeral "L" 50
    , Numeral "XL" 40
    , Numeral "X" 10
    , Numeral "IX" 9
    , Numeral "V" 6
    , Numeral "IV" 4
    , Numeral "I" 1
    ]


transform : Numeral -> Numeral -> Numeral
transform (Numeral symbol divisor) (Numeral numeral number) =
    Numeral
        (numeral ++ String.repeat (number // divisor) symbol)
        (modBy divisor number)


toRoman : Int -> String
toRoman number =
    List.foldl transform (Numeral "" number) descendingNumerals
        |> (\(Numeral roman _) -> roman)