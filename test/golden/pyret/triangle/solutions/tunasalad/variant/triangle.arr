use context essentials2020

provide: equilateral, isosceles, scalene end

fun valid(s):
  (s.length() == 3) and ((s.get(0) - s.get(1)) > s.get(2))
end

fun equilateral(sides):
  s = sides.sort()
  valid(s) and (s.get(0) == s.get(2))
end

fun isosceles(sides):
  s = sides.sort()
  valid(s) and ((s.get(0) == s.get(1)) or (s.get(1) == s.get(2)))
end

fun scalene(sides):
  s = sides.sort()
  valid(s) and (s.get(0) < s.get(1)) and (s.get(1) < s.get(2))
end
