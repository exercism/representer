open Base

let empty = Map.empty (module Char)

let is_nucleotide = function
  | 'A' | 'C' | 'G' | 'T' -> true
  | _ -> false
;;

let count_nucleotide s c =
  if not (is_nucleotide c)
  then Error c
  else String.fold_result s
         ~init:0
         ~f:(fun acc elt ->
           if Char.(elt = c) then Ok (acc + 1)
           else if is_nucleotide elt then Ok acc
           else Error elt)
;;

let count_nucleotides s =
  let f acc x =
    if is_nucleotide x
    then Ok (Map.update acc x
               ~f:(Option.value_map
                     ~f:((+) 1)
                     ~default:1))
    else Error x
  in
  String.fold_result s
    ~init: empty
    ~f:f
;;
