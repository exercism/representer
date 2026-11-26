module Pangram exposing (isPangram)


isPangram : String -> Bool
isPangram sentence =
    let
        sent = String.toList <| String.toLower sentence
        alpha = String.toList "abcdefghijklmnopqrstuvwxyz"
    in
    alpha
        |> List.any (\c -> List.member c sent)