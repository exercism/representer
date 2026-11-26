module SecretHandshake exposing (Command(..), commands)


type Command
    = Wink
    | DoubleBlink
    | CloseYourEyes
    | Jump


commands : Int -> List Command
commands number =
    let
        ints =
            toBinary number

        commandList =
            ints
                |> List.map2 Tuple.pair [ Wink, DoubleBlink, CloseYourEyes, Jump ]
                |> List.filterMap
                    (\( command, int ) ->
                        if int == 1 then
                            Just command

                        else
                            Nothing
                    )
    in
    if List.drop 4 ints == [ 1 ] then
        List.reverse commandList

    else
        commandList


toBinary : Int -> List Int
toBinary n =
    if n == 0 then
        []

    else
        modBy 2 n :: toBinary (n // 2)
