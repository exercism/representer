let transform many_to_one = let rec auxi score = function
  | [] -> []
  | h::t -> (Char.uppercase_ascii h, score)::(auxi score t) in
  let rec auxj = function
  | [] -> []
  | h::t -> (auxi (fst h) (snd h))::(auxj t) in
  let flat = List.flatten (auxj many_to_one) in
  List.sort Stdlib.compare flat