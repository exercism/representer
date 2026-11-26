module PhoneNumber exposing (getNumber)

import Parser exposing (Parser, (|.), (|=))


getNumber : String -> Maybe String
getNumber =
    Parser.run phoneNumber >> Result.toMaybe


phoneNumber : Parser String
phoneNumber =
    Parser.succeed (\area exchange num -> area ++ exchange ++ num)
        |. nonDigit
        |. optionalCountryCode
        |. nonDigit
        |= code
        |. nonDigit
        |= code
        |. nonDigit
        |= number
        |. nonDigit
        |. Parser.end


code : Parser String
code =
    Parser.succeed (\a b c -> a ++ b ++ c)
        |= notZeroOrOne
        |= digit
        |= digit


notZeroOrOne : Parser String
notZeroOrOne =
    Parser.oneOf
        [ badDigit "0"
        , badDigit "1"
        , digit
        ]

badDigit : String -> Parser String
badDigit =
    Parser.token
        >> Parser.andThen (always <| Parser.problem "bad digit")

number : Parser String
number =
    Parser.succeed (\a b c d -> a ++ b ++ c ++ d)
        |= digit
        |= digit
        |= digit
        |= digit


digit : Parser String
digit =
    Parser.chompIf Char.isDigit
        |> Parser.getChompedString


nonDigit : Parser ()
nonDigit =
    Parser.chompWhile (not << Char.isDigit)


optionalCountryCode : Parser ()
optionalCountryCode =
    Parser.oneOf
        [ Parser.chompIf ((==) '1')
        , Parser.succeed ()
        ]