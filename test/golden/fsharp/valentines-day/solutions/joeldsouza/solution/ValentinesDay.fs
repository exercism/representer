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

let rateActivity (activity: Activity): Approval = 
    match activity with
        | BoardGame -> Approval.No
        | Chill -> Approval.No
        | Movie i ->
            match i with 
                | Romance -> Approval.Yes
                | _ -> Approval.No
        | Restaurant i ->
            match i with 
                | Korean -> Approval.Yes
                | Turkish -> Approval.Maybe
        | Walk i ->
            if i < 3 then Approval.Yes 
            elif i < 5 then Approval.Maybe 
            else Approval.No 
