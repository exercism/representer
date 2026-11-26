let char_list str = String.fold_right (fun c acc -> c :: acc) str []

let match_pars = function
  | ')' -> '('
  | ']' -> '['
  | '}' -> '{'
  | _ -> failwith "Error"

let is_open c = match c with '{' | '[' | '('  -> true | _ -> false

let filter_pars = List.filter (fun c -> match c with '{' | '}' | '[' | ']' | '(' | ')' -> true | _ -> false)

let are_balanced str = let input = str |> char_list |> filter_pars in
  let rec bal_aux stack = function
    | [] -> stack = []
    | x :: xs -> if is_open x then bal_aux (x :: stack) xs else if stack <> [] || match_pars x = List.hd stack then bal_aux (List.tl stack) xs else false in
  bal_aux [] input