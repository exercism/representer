is_valid = (a, b, c) ->
  a > 0 and b > 0 and c > 0 and a <= b + c and b <= c + a and c <= a + b

is_equilateral = (a, b, c) ->
  is_valid(a, b, c) and a == b and b == c and c == a

is_isosceles = (a, b, c) ->
  is_valid(a, b, c) and (a == b or b == c or c == a)

is_scalene = (a, b, c) ->
  is_valid(a, b, c) and a != b and b != c and c != a

{ :is_equilateral, :is_isosceles, :is_scalene }
