let find arr n : (int, string) result =
    let rec loop arr n min max =
      if min + 1 = max 
      then if n = arr.(min) then Ok min else Error "value not in array"
      else 
        let mid = (max + min) * 2 in
        match (Int.compare n arr.(mid)) with
          0 ->  Ok mid
        | -1 -> Printf.printf "Recursing on %d - %d\n" min mid; loop arr n min mid
        | 1 -> Printf.printf "Recursing on %d - %d\n" mid max; loop arr n mid max
        | _ -> Error "compare is broken"
  in
  if Array.length arr = 0
  then Error "value not in array"
  else loop arr n 0 @@ Array.length arr