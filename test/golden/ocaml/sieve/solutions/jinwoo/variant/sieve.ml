let for_step ~start ~finish ~step f =
  let rec aux i =
    if i >= finish then ()
    else (
      f i;
      aux (i + step))
  in
  aux start

let sieve flags limit n =
  let rec aux k =
    if k > limit then ()
    else if not flags.(k) then aux (k + 1)
    else
      let len = Array.length flags in
      for_step ~start:(k + k) ~finish:(len - 1) ~step:k (fun i ->
          flags.(i) <- false);
      aux (k + 1)
  in
  aux n

let primes n =
  let flags = Array.make (n + 1) true in
  let limit = n |> float_of_int |> sqrt |> int_of_float in
  sieve flags limit 2;
  let result = ref [] in
  for i = n downto 2 do
    if flags.(i) then result := i :: !result
  done;
  !result
