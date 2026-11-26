tri_check_with = (fn) ->
  (...) ->
    -- sort 3 sides
    t = {...}
    table.sort t
    {a, b, c} = t
    -- check tri-ineq. and then fn
    a + b > c and fn a, b, c

{
  is_equilateral: tri_check_with (a, _, c) -> a == c
  is_isosceles:   tri_check_with (a, b, c) -> a == b or b == c
  is_scalene:     tri_check_with (a, b, c) -> a < b and b < c
}
