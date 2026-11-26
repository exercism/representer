open Base

let empty = Map.empty (module Char)

let count_nucleotide s c =
  match (s, c) with
  | _, 'X' -> Error 'X'
  | s, c ->
      let rec find_occurences lst_s c acc =
        match (lst_s, c, acc) with
        | x :: xs, c, acc when Char.( = ) c x -> find_occurences xs c (acc + 1)
        | x :: _, _, _ when Char.( = ) x 'X' -> Error 'X'
        | _ :: xs, _, _ -> find_occurences xs c acc
        | [], _, acc -> Ok acc
      in

      find_occurences (String.to_list s) c 0

let addkey c count m =
  match m with Ok m' -> Map.set m' ~key:c ~data:count | Error _ -> empty

let count_nucleotides s =
  let counts =
    List.map [ 'A'; 'C'; 'T'; 'G' ] ~f:(fun x -> (x, count_nucleotide s x))
  in

  let rec traverse counts =
    match counts with
    | (_, Error _) :: _ -> Error 'X'
    | (_, Ok 0) :: xs -> traverse xs
    | (c, Ok count) :: xs ->
        let m' = traverse xs in
        Ok (addkey c count m')
    | [] -> Ok empty
  in

  traverse counts
