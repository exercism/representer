let score (x: float) (y: float): int =
  let z = (x *. x) +. (y *. y) 
  in if z <= 1. then 10
      else if z <= 25. then 5
      else if z < 100. then 1
      else 0
;;
