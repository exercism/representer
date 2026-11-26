let roman_number_map =
  [ (1000, "M")
  ; (500, "D")
  ; (100, "C")
  ; (50, "L")
  ; (10, "X")
  ; (5, "V")
  ; (1, "I")
  ; (900, "CM")
  ; (400, "CD")
  ; (90, "XC")
  ; (40, "XL")
  ; (9, "IX")
  ; (4, "IV") ]

let pow n p =
  let rec aux n p acc = if p <= 0 then acc else aux n (p - 1) (acc * n) in
  aux n p 1

let nb_len n =
  let rec aux n acc = if n = 0 then acc else aux (n / 10) (acc + 1) in
  aux n 0

let arabic_to_roman n =
  let len = nb_len n - 1 in
  let iterations = n / pow 10 len in
  let r1 = List.find_opt (fun (nb, _) -> nb = n) roman_number_map in
  let r2 = List.find_opt (fun (nb, _) -> nb = iterations) roman_number_map in
  match [r1; r2] with
  | [Some (_, l1); _] ->
      l1
  | [_; Some (_, l2)] ->
      String.init len (fun _ -> l2.[0])
  | _ ->
      if n < 4 then String.init n (fun _ -> 'I')
      else if n < 10 then "V" ^ String.init (n - 5) (fun _ -> 'I')
      else if n < 40 then String.init iterations (fun _ -> 'X')
      else if n < 100 then "L" ^ String.init (iterations - 5) (fun _ -> 'X')
      else if n < 400 then String.init iterations (fun _ -> 'C')
      else if n < 1000 then "D" ^ String.init (iterations - 5) (fun _ -> 'C')
      else String.init iterations (fun _ -> 'M')

let to_roman n =
  let rec decompose_number n p acc =
    if n = 0 then acc
    else
      let next = n mod pow 10 p in
      decompose_number next (p - 1) ((n - next) :: acc)
  in
  let l = decompose_number n (nb_len n + 1) [] in
  List.map arabic_to_roman l |> List.rev
  |> List.filter (fun s -> s <> "")
  |> List.fold_left ( ^ ) ""
