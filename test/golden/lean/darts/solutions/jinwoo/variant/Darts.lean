namespace Darts

def score (x : Float) (y : Float) : Int :=
  let dist := (x^2 + y^2).sqrt
  if dist > 10 then 0
  else if dist >= 5 then 1
  else if dist > 1 then 5
  else 10

end Darts
