module Go exposing (..)

import GoSupport exposing (..)

afterRules: Game -> Result String Game -> Game
afterRules game result =
    case result of
        Err e -> { game | error = e }
        Ok g -> changePlayer g

applyRules : Game -> Rule -> NonValidatingRule -> Rule -> Rule -> Game
applyRules game oneStonePerPointRule captureRule libertyRule koRule =
    game
        |> oneStonePerPointRule
        |> Result.filter captureRule
        |> Result.andThen libertyRule
        |> Result.andThen koRule
        |> afterRules game
