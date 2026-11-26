let is_prime n =
  if n < 2 then false
  else if n = 2 || n = 3 then true
  else if n mod 2 = 0 || n mod 3 = 0 then false
  else
    let rec check d =
      if d * d > n then true
      else if n mod d = 0 || n mod (d + 2) = 0 then false
      else check (d - 6)
    in
    check 5

let nth_prime n =
  if n <= 0 then
    Error "there is no zeroth prime"
  else if n = 1 then
    Ok 2
  else
    let rec find count candidate =
      if is_prime candidate then
        if count + 1 = n then candidate
        else find (count + 1) (candidate + 2)
      else
        find count (candidate + 2)
    in
    Ok (find 1 3)