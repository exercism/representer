open Base
open Result.Monad_infix

let nucleotides = [ 'A'; 'C'; 'G'; 'T' ]
let is_valid = function 'A' | 'C' | 'G' | 'T' -> true | _ -> false

let count_nucleotide s c =
  match is_valid c with
  | false -> Error c
  | true ->
      String.fold s ~init:(Ok 0) ~f:(fun acc ch ->
          acc >>= fun n ->
          match (is_valid ch, Char.equal ch c) with
          | false, _ -> Error ch
          | _, true -> Ok (n + 1)
          | _, false -> Ok n)

let count_nucleotides s =
  String.fold s
    ~init:(Ok (Map.empty (module Char)))
    ~f:(fun acc ch ->
      acc >>= fun map ->
      match is_valid ch with
      | false -> Error ch
      | true ->
          Ok (Map.update map ch ~f:(fun n -> 1 + Option.value n ~default:0)))
