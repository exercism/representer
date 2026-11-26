module ValentinesDay

type Approval =
    | Yes
    | No
    | Maybe

type Cuisine =
    | Korean
    | Turkish

type Genre =
    | Crime
    | Horror
    | Romance
    | Thriller

type Activity =
    | BoardGame
    | Chill
    | Movie of Genre
    | Restaurant of Cuisine
    | Walk of int

let rateActivity: Activity -> Approval =
    function
    | BoardGame -> No
    | Chill -> No
    | Movie genre ->
        match genre with
        | Romance -> Yes
        | _ -> No
    | Restaurant cuisine ->
        match cuisine with
        | Korean -> Yes
        | Turkish -> Maybe
    | Walk length ->
        match length with
        | length when length < 3 -> Yes
        | length when length < 5 -> Maybe
        | _ -> No
