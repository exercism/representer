use context essentials2020 # Don't delete this line when using Pyret on Exercism 

provide: egg-count end

fun loop(remaining :: NumInteger, result :: NumInteger):
  if remaining == 0:
    result
  else:
    loop(num-floor(remaining / 2), result + num-modulo(remaining, 2))
  end
end

fun egg-count(n :: NumInteger):
  loop(n, 0)
end