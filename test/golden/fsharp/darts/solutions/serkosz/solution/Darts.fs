module Darts

let score (x: double) (y: double): int =     
  let r = sqrt(x ** 2.0 + y ** 2.0)           
  if r <= 1.0 then 10
  elif r <= 5.0 then 5
  elif r <= 10.0 then 1
    else 0
