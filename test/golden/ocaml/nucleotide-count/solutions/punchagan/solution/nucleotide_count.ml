open Base

let empty = Map.empty (module Char)
let is_nucl = function 'A' | 'T' | 'G' | 'C' -> true | _ -> false

let count_nucleotides s =
  String.fold_result s ~init:empty ~f:(fun m c ->
      if is_nucl c
      then Ok (Map.update m c ~f:(Option.value_map ~f:Int.succ ~default:1))
      else Error c)

let count_nucleotide s c =
  let incr n = function
    | c' when is_nucl c' -> Ok (if Char.equal c' c then n + 1 else n)
    | c' -> Error c'
  in
  if is_nucl c then String.fold_result s ~init:0 ~f:incr else Error c
