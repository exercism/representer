module TwoFer exposing (twoFer)
import String exposing (..)

twoFer : Maybe String -> String
twoFer name = 
    let 
        stname =
            name 
                |> Maybe.withDefault "you"
    in 
        "One for " ++  stname ++ ", one for me."
