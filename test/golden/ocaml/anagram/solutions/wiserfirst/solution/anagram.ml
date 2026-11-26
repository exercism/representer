let anagrams input candidates =
  let downcase_charlist s =
    s |> String.lowercase_ascii |> String.to_seq |> List.of_seq
  in
  let sort_fun = List.sort Char.compare in
  let lowercased = downcase_charlist input in
  let sorted = sort_fun lowercased in
  let predicate candidate =
    let lower_candidate = downcase_charlist candidate in
    lower_candidate <> lowercased && sort_fun lower_candidate = sorted
  in
  List.filter predicate candidates
