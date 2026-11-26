open Base

let is_anagram str1 str2 =
  let str1 = String.lowercase str1 in
  let str2 = String.lowercase str2 in
  let str1 = String.to_list str1 in
  let str2 = String.to_list str2 in
  match List.equal Char.equal str1 str2 with
  | true -> false
  | false ->
    let str1 = List.sort ~compare:Char.compare str1 in
    let str2 = List.sort ~compare:Char.compare str2 in
    List.equal Char.equal  str1 str2

let anagrams str str_list =
  let rec aux str str_list acc =
    match str_list with
    | [] -> acc
    | hd::tl -> if is_anagram str hd then aux str tl (hd::acc) else aux str tl acc
  in aux str str_list [] |> List.rev

