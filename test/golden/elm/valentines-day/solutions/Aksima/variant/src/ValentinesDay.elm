module ValentinesDay exposing (..)


type Approval
    = Yes
    | No
    | Maybe


type Cuisine
    = Korean
    | Turkish


type Genre
    = Crime
    | Horror
    | Romance
    | Thriller


type Activity
    = BoardGame
    | Chill
    | Movie Genre
    | Restaurant Cuisine
    | Walk Int


rateActivity : Activity -> Approval
rateActivity activity =
    case activity of
        Movie Romance ->
            Yes

        Restaurant cuisine ->
            case cuisine of
                Korean ->
                    Yes

                Turkish ->
                    Maybe

        Walk distance ->
            if distance < 3 then Yes
            else if distance <= 5 then Maybe
            else No

        _ -> No
