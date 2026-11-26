let all =
  let rec aux = function 123 -> [] | n -> char_of_int n :: aux (n + 1) in
  aux 97

let to_pieces = String.fold_left (fun acc c -> c :: acc) []

let filter =
  List.filter_map (fun c -> if 'a' <= c && c <= 'z' then Some c else None)

let usort = List.sort_uniq (fun a b -> Char.compare a b)

let is_pangram sent =
  sent |> String.lowercase_ascii |> to_pieces |> filter |> usort
  |> List.equal (fun a b -> Char.equal a b) all
