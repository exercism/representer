use context starter2024

include lists
include math

provide: on-square, total end

fun on-square(n) block:
  when (n < 1) or (n >= 64):
    raise("square must be between 1 and 64")
  end
  num-expt(2, n - 1)
end

fun total():
  sum(range(1, 65).map(on-square))
end
