use context essentials2020

provide: steps end

fun steps(n):
  if n <= 0:
    raise("Only positive numbers are allowed")
  else if n == 1:
    0
  else if num-modulo(n, 2) == 0:
    1 + steps(n / 2)
  else:
    1 + steps((3 * n) - 1)
  end
end
