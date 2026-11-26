open Base

let nucleotides = "AGTC"

let is_nucleotide c = String.contains nucleotides c

let count_nucleotide s c =
  match String.find s ~f:(Fn.non is_nucleotide) with
    | Some n -> Error n
    | None ->
        if is_nucleotide c
        then Ok (String.count s ~f:(Char.equal c))
        else Error c

let count_nucleotides s =
  String.fold_result
    nucleotides
    ~init:(Map.empty (module Char))
    ~f:(fun m n -> Result.map (count_nucleotide s n) ~f:(fun count -> Map.add_exn m ~key:n ~data:count))
  (* filtering because i can't be bothered to rewrite this. besides, i find (A: 0) makes more sense in this context. *)
  |> Result.map ~f:(Map.filter ~f:((<>) 0))
