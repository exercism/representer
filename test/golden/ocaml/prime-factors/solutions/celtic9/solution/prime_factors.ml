let factors_of (n:int64) = 
  let open Int64 in
  let rec fac_aux acc (n:int64) (divi:int64) =
    if equal n 1L then acc else
      if equal (rem n divi) 0L then fac_aux (divi :: acc) (div n divi) 2L else
        fac_aux acc n (add divi 1L) in
  fac_aux [] n 2L |> List.sort Int64.compare