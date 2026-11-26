open Base

let empty = Map.empty (module Char)

let add map c =
  let update count_opt =
    let count = Option.value count_opt ~default:0 in
    Option.some (count + 1)
  in
  Map.change ~f:update map c

let count word =
  String.lowercase word |> String.to_list |> List.fold ~init:empty ~f:add

let anagrams word words =
  let word_count = count word in
  let is_different w = not String.(equal (lowercase w) (lowercase word)) in
  List.filter
    ~f:(fun w -> is_different w && Map.equal Int.equal word_count (count w))
    words
