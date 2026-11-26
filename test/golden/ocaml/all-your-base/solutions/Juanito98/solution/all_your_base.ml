type base = int

let convert_bases ~from ~digits ~target =
    if from < 2 || target < 2 || not (List.for_all (fun d -> d >= 0 && d < from) digits) then None else
    let b = ref 1 in
    let num = digits |> List.rev |> List.fold_left (fun acc d -> (
      let s = acc + !b * d in
      b := !b * from;
      s
    )) 0 in
    let rec to_list (n:base) = 
      if n < target then [n]
      else n mod target :: to_list (n / target)
    in
    Some (to_list num |> List.rev)