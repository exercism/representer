let valid_triangle a b c =
  a + b >= c &&
  a + c >= b &&
  b + c >= a &&
  a > 0 && b > 0 && c > 0

let is_equilateral a b c =
  valid_triangle a b c && a = b && b = c

let is_isosceles a b c =
  valid_triangle a b c && (a = b || b = c || a = c)

let is_scalene a b c =
  valid_triangle a b c && (a <> b && b <> c && a <> c)