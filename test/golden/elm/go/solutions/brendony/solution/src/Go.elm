module Go exposing (..)

import GoSupport exposing (..)
import Result exposing (andThen)


applyRules : Game -> Rule -> NonValidatingRule -> Rule -> Rule -> Game
applyRules game oneStonePerPointRule captureRule libertyRule koRule =
    -- Debug.todo "Please implement the `applyRules` function"
    let
        result =
            oneStonePerPointRule game
                |> andThen (wrapNonValidatingRule captureRule)
                |> andThen libertyRule
                |> andThen koRule
    in
    case result of
        Ok newGame ->
            changePlayer newGame

        Err error ->
            { game | error = error }


wrapNonValidatingRule : NonValidatingRule -> Game -> Result String Game
wrapNonValidatingRule nonValidatingRule game =
    Result.Ok (nonValidatingRule game)
