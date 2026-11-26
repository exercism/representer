local triangle = {}

function triangle.type(a, b, c)
  if a == b and b == c then
    return "equilateral"
  elseif a == b or b == c or a == c then
    return "isosceles"
  else
    return "scalene"
  end    
end

function triangle.kind(a, b, c)
  local is_null = a == 0 and b == 0 and c == 0
  local is_triangle = a + b >= c and b + c >= a and a + c >= b
  
  if is_null or not is_triangle then
    return error("Input Error")
  else
    return triangle.type(a, b, c)
  end
end

return triangle
