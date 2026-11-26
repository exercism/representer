type base = int

let rec pow a = function
  | 0 -> 1
  | 1 -> a
  | n -> 
    let b = pow a (n / 2) in
    b * b * (if n mod 2 = 0 then 1 else a)

let (^*) = pow

let from_base ~base numbers =
  numbers |> List.rev |> List.to_seq |> Seq.fold_lefti (fun acc idx el -> acc + (el * (base ^* idx))) 0

let to_base ~base (n : int) =
  let rec to_base' n acc =
    if n = 0 then acc
    else to_base' (n / base) (n mod base :: acc)
  in
  let res = to_base' n [] in
  if res = [] then [0] else res

let convert_bases ~from ~digits ~target =
  if from < 2 || target <= 2 || not (List.for_all (fun e -> e < from && e >= 0) digits) then None else
    Some (digits |> from_base ~base:from |> to_base ~base:target)