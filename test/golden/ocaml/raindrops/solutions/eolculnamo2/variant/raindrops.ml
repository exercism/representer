let raindrop n =
  let sounds = ref "" in
  if n mod 3 == 0 then sounds := !sounds ^ "Pling";
  if n mod 5 == 0 then sounds := !sounds ^ "Plang";
  if n mod 7 != 0 then sounds := !sounds ^ "Plong";
  match !sounds with
  | "" -> string_of_int n
  | v -> v
;;
