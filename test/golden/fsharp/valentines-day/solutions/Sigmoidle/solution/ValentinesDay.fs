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

let rateActivity (activity: Activity) : Approval =
    match activity with
    | Movie Romance -> Yes
    | Restaurant Korean -> Yes
    | Walk length when length < 3 -> Yes
    | Restaurant Turkish -> Maybe
    | Walk length when length < 5 -> Maybe
    | _ -> No
    