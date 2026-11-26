use context essentials2020 # Don't delete this line when using Pyret on Exercism 

provide: steps end

fun steps(n):
  # raise("Please implement the steps function")
  if n <= 0:
    raise("Only positive numbers are allowed")
  else if n == 1:
    0
  else if num-modulo(n, 2) != 0:
    1 + steps(num-truncate(n / 2))
  else:
    1 + steps((3 * n) + 1)
  end
end
