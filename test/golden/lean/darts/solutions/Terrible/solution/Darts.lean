namespace Darts

def score (x : Float) (y : Float) : Int :=
  ite (x^2+y^2<=1^2) 10 (ite (x^2+y^2<=5^2) 5 (ite (x^2+y^2<=10^2) 1 0))

end Darts
