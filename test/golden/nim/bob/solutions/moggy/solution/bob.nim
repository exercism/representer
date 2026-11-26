import strutils
proc shouting(s: string): bool =
  s == s.toUpperAscii and s.contains(Letters)

proc question(s: string): bool =
  s.strip.endsWith('?')

proc hey*(s: string): string =
  if   s.isEmptyOrWhitespace: "Fine. Be that way!"
  elif s.question and s.shouting: "Calm down, I know what I'm doing!"
  elif s.shouting: "Whoa, chill out!"
  elif s.question: "Sure."
  else: "Whatever."
