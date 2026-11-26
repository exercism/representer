open Base
open Base.Continue_or_stop

let empty = Map.empty (module Char)

let is_nucleotide = function
  | 'A' | 'C' | 'G' | 'T' -> true
  | _ -> false

let count_nucleotide s c =
  match (is_nucleotide c) with
  | false -> Error c
  | true -> String.fold_until s
              ~init:0
              ~finish:Result.return
              ~f:(fun count n -> if not (is_nucleotide n) 
                   then Stop (Error n) 
                   else Continue (if Char.equal c n then count + 1 else count))

let incr = Map.change ~f:(function
    | None -> Some 1
    | Some n -> Some (n + 1))

let count_nucleotides =
  String.fold_until
    ~init:empty
    ~finish:Result.return
    ~f:(fun nucleotides c -> if is_nucleotide c
         then Continue (incr nucleotides c)
         else Stop (Error c))