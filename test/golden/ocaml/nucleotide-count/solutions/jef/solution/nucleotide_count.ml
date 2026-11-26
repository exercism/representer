open Base

let empty = Map.empty (module Char)
let is_char_valid c = match c with 'C' | 'A' | 'G' | 'T' -> true | _ -> false

let find_invalid_char s =
  String.to_list s |> List.find ~f:(fun c -> not (is_char_valid c))
;;

let count_char char_list c =
  List.fold char_list ~init:0 ~f:(fun count char ->
      if Char.( = ) char c then count + 1 else count )
;;

let count_nucleotide s c =
  if not (is_char_valid c)
  then Error c
  else
    let char_list = String.to_list s in
    match find_invalid_char s with
    | Some c -> Error c
    | None -> Ok (count_char char_list c)
;;

let get_new_count map char = match Map.find map char with None -> 1 | Some x -> x + 1

let map_chars s =
  String.to_list s
  |> List.fold ~init:empty ~f:(fun map char ->
         Map.set map ~key:char ~data:(get_new_count map char) )
;;

let count_nucleotides s =
  match find_invalid_char s with Some c -> Error c | None -> Ok (map_chars s)
;;
