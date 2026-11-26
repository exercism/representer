let char_to_int (c : char) : int option =
  let open Char in
  if c >= '0' && c <= '9' then Some (code c - code '0') else None

let char_to_int_last (c : char) : int option =
  let open Char in
  if c >= '0' && c <= '9' then Some (code c - code '0')
  else if c = 'X' || c = 'x' then Some 10
  else None

let parse (input : string) : (int list, string) result =
  let strlen = String.length input in
  let rec loop acc idx digits =
    if idx >= strlen then
      if digits = 10 then Ok (List.rev acc) else Error "Not enough digits"
    else
      match input.[idx] with
      | '-' -> loop acc (idx + 1) digits
      | c -> (
          if digits = 9 then
            if idx <> strlen - 1 then Error "Too many characters"
            else
              match char_to_int_last c with
              | None -> Error "Invalid character in check digit"
              | Some x -> Ok (List.rev (x :: acc))
          else
            match char_to_int c with
            | None -> Error "Invalid character"
            | Some x -> loop (x :: acc) (idx + 1) (digits + 1))
  in
  loop [] 0 0

let is_valid input =
  match parse input with
  | Error _ -> false
  | Ok l ->
      let _, sum =
        List.fold_left
          (fun (coeff, v) x -> (coeff - 1, (coeff * x) + v))
          (10, 0) l
      in
      sum mod 11 = 0
