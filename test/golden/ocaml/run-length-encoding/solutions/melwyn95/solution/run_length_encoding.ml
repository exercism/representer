let encode data = data
  |> String.fold_left (fun (xs, (prev, count)) curr ->
    match prev with
    | None -> xs, (Some curr, 1)
    | Some prev when Char.equal prev curr -> xs, (Some prev, count + 1)
    | Some prev -> (prev, count) :: xs, (Some curr, 1)) ([], (None, 0))
  |> (fun (xs, (prev, count)) ->
      match prev with
      | None -> xs
      | Some prev -> (prev, count) :: xs)
  |> List.fold_left (fun enc (ch, count) ->
      (if count = 1 
       then "" 
       else (string_of_int count)) 
      ^ (Char.escaped ch) 
      ^ enc) ""

let rec repeat c = function 
  | 1 -> Char.escaped c 
  | n -> Char.escaped c ^ repeat c (n - 1)

let decode rle = rle
  |> String.fold_left (fun (xs, num_opt) ch ->
    match num_opt with
    | None ->
      let cmp = int_of_char ch - int_of_char '0' in
      if cmp >= 0 && cmp <= 9
      then xs, Some cmp
      else (1, ch) :: xs, None
    | Some n ->
      let cmp = int_of_char ch - int_of_char '0' in
      if cmp >= 0 && cmp <= 9
      then xs, Some (10 * n + cmp)
      else (n, ch) :: xs, None) ([], None)
  |> fun (xs, _) -> List.rev xs
  |> List.map (fun (n, c) -> repeat c n)
  |> String.concat ""
