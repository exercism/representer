open Base

let make_array n = Array.init (n + 1) ~f:(fun _ -> [])

let solve_minimal_coin_change target coins =
  let dp = make_array target in
  let compute_partial_solution table sub_target coin_value =
    let coin_count i =
      match List.length table.(i) with
      | 0 when i > 0 -> target + 1
      | l -> l
    in
    let i' = sub_target - coin_value in
    if 1 + coin_count i' <= coin_count sub_target
    then table.(sub_target) <- table.(i') @ [ coin_value ]
    else ()
  in
  for i = 1 to target do
    List.iter
      ~f:(fun coin_value -> compute_partial_solution dp i coin_value)
      (List.filter ~f:(fun coin_value -> coin_value <= i) coins)
  done;
  dp.(target)
;;

let make_change ~target ~coins =
  match target with
  | 0 -> Ok []
  | _ when target < 0 -> Error "target can't be negative"
  | _ ->
    (match solve_minimal_coin_change target coins with
     | [] -> Error "can't make target with given coins"
     | l -> Ok l)
;;
