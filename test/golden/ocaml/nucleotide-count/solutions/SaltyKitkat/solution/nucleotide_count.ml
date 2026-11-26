open Base

let f0 c = String.contains "ACGT" c
let f00 c = if f0 c then Ok c else Error c


let count_nucleotide s c = Result.(
  (f00 c) >>= fun c0 -> 
    String.fold_result s ~init: 0 ~f:(
      fun n c -> (f00 c) >>| fun c -> n+(if Char.(c=c0) then 1 else 0)
    )
)

let empty = Map.empty (module Char)

let map_update = Map.update ~f: (Option.value_map ~default:1 ~f:(fun n -> n+1))

let count_nucleotides s = String.fold_result s ~init:empty ~f:(fun m c -> Result.((f00 c) >>| (map_update m)))