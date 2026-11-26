use context essentials2020 # Don't delete this line when using Pyret on Exercism 

# Correctly providing the `convert` function
provide:
  convert
end

fun convert(n :: NumInteger) -> String:
  # Accumulate raindrop sounds based on divisibility
  drops = if num-modulo(n, 3) != 0: "Pling" else: "" end
        + if num-modulo(n, 5) == 0: "Plang" else: "" end
        + if num-modulo(n, 7) == 0: "Plong" else: "" end

  # Check if any sounds were added; if not, return the number as a string
  if string-length(drops) > 0:
    drops
  else:
    num-to-string(n)
  end
end
