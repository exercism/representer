namespace Triangle

private
def isTriangle (a b c : Float) : Bool :=
  a > 0 && b > 0 && c > 0 &&
  a + b ≥ c && b + c ≥ a && a + c ≥ b

def equilateral : (sides : List Float) → Bool
  | [a, b, c] => isTriangle a b c && a == b && b == c
  | _ => false

def isosceles : (sides : List Float) → Bool
  | [a, b, c] => isTriangle a b c && (a == b || b == c || c == a)
  | _ => false

def scalene : (sides : List Float) → Bool
  | [a, b, c] => isTriangle a b c && a != b && b != c && c != a
  | _ => false

end Triangle
