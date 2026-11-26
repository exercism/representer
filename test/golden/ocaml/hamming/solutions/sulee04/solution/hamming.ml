type nucleotide = A | C | G | T

let hamming_distance a b =
  if List.length a = List.length b then
    List.combine a b 
    |> List.map (fun x -> if fst x = snd x then 0 else 1) 
    |> List.fold_left (+) 0
    |> fun x -> Ok x
  else Error "strands must be of equal length"
