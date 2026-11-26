let rec do_change target change = function
  | [] -> []
  | h :: t when h > target -> do_change target change t
  | h :: _ when target - h = 0 -> h :: change
  | h :: t as coins ->
    match do_change (target - h) (h :: change) coins with
    | [] -> do_change target change t
    | chg -> chg

let rec do_changes target = function
  | [] -> []
  | _ :: t as coins -> (do_change target [] coins) :: (do_changes target t)

let make_change ~target ~coins =
  if target < 0 then Error "target can't be negative"
  else
    match do_changes target (List.rev coins)
          |> List.filter (fun l -> List.length l > 0)
          |> List.sort (fun a b -> compare (List.length a) (List.length b))
    with
    | [] when target = 0 -> Ok []
    | [] -> Error "can't make target with given coins"
    | chg :: _ -> Ok chg
