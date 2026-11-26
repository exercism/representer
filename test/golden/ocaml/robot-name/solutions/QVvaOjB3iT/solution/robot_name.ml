type robot = string ref

module StrSet = Set.Make(String)
let name_db = ref StrSet.empty

let rec new_name () =
  let rec aux i acc =
    if i = 5 then
      let name = acc
        |> List.rev
        |> List.to_seq
        |> String.of_seq
      in
      if StrSet.mem name !name_db then
        new_name ()
      else
        name
    else if i < 2 then
      let s = Random.int (90 - 65 + 1) + 65 |> char_of_int in
      aux (i + 1) (s :: acc)
    else
      let s = Random.int (57 - 48 + 1) + 48 |> char_of_int in
      aux (i + 1) (s :: acc)
  in
  aux 0 []

let new_robot () : robot =
  ref (new_name ())

let name robot = 
  !robot

let reset robot =
  robot := new_name ()
