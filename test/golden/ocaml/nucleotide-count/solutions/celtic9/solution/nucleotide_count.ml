open Base
open Base.Char
open Base.Result
let empty = Map.empty (module Char)

let valid_nuc = function
  | 'A' | 'C' | 'G' | 'T' -> true
  | _ -> false

let count_nucleotide s c = if valid_nuc c then
  String.fold s ~init:(Ok 0) ~f:(
    fun acc el -> if valid_nuc el then 
      if el = c then (acc >>= (fun n -> Ok (n + 1))) else acc
  else Error el)
else Error c


let count_nucleotides s =
  let nucs = List.dedup_and_sort (String.to_list s) ~compare:(Char.compare) in
    List.fold nucs ~init:(Ok empty) ~f:(fun acc nuc -> count_nucleotide s nuc >>= fun n -> acc >>= fun m -> Ok (Map.set m ~key:nuc ~data:n))