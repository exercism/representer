module TwoFer exposing (twoFer)


twoFer : Maybe String -> String
twoFer name =
    let
        emptyStrToNothing s =
            if String.isEmpty s then
                Nothing

            else
                Just s

        for =
            name
                |> Maybe.andThen emptyStrToNothing
                |> Maybe.withDefault "you"
    in
    "One for " ++ for ++ ", one for me."
