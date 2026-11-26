let explode point chars =
  let rec helper acc lst =
    match lst with
    | [] -> acc
    | h :: t -> helper (((Char.uppercase_ascii h), point) :: acc) t
  in helper [] chars

let transform lst =
    let rec helper acc sublist =
      match sublist with
      | [] -> acc
      | (point, chars) :: t -> let exploded = explode point chars in
        helper (exploded @ acc) t
    in List.sort (fun (c1, p1) (c2, p2) -> Char.compare c1 c2) (helper [] lst)