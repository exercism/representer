use context essentials2020 # Don't delete this line when using Pyret on Exercism 

provide: reversed end

fun reversed(text):
  chars = string-to-code-points(text)
  string-from-code-points(chars.reverse())
end