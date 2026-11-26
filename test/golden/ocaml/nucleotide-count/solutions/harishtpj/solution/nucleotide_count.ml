open Base

let is_nucl = function
    | 'A' | 'C' | 'G' | 'T' -> true
    | _ -> false

let empty = Map.empty (module Char)

let count_nucleotide s c =
  match String.find s ~f:(Fn.non is_nucl) with
        | None ->
            if is_nucl c
            then Ok (String.count s ~f:(Char.equal c))
            else Error c
        | Some c' -> Error c'

let count_nucleotides s =
  String.fold_result s
    ~init:empty
    ~f:(fun m c -> 
        if is_nucl c
        then Ok (Map.update m c
                   ~f:(Option.value_map ~f:((+) 1) ~default:1))
        else Error c)
