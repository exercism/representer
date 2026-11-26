open Base

let empty = Map.empty (module Char)

let valid_nucleotide n = 
  match n with 
  | 'A' | 'G' | 'T' | 'C' -> true
  | _ -> false

let get_nucleotide_count n map = 
  match Map.find map n with
  | Some v ->  v
  | None -> 0

let inc_nucleotide_count = function
  | Some v -> v + 1
  | None -> 1

let rec counter f acc s = 
  match s with 
  | [] -> Ok (f acc)
  | h :: t -> 
    match valid_nucleotide h with
    | true -> counter f (Map.update acc h ~f:inc_nucleotide_count) t
    | false -> Error h

let count_nucleotide s c =
  match valid_nucleotide c with
  | true -> counter (get_nucleotide_count c) empty (String.to_list s)
  | false -> Error c

let count_nucleotides s =
  counter (fun map -> map) empty (String.to_list s)
