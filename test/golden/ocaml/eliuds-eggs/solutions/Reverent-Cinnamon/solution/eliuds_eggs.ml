let egg_count number =
  let rec aux number count =
    if number = 0 then count
    else 
      aux (number lsr 1) (count + (number land 1))
  in 
  aux number 0
;;
