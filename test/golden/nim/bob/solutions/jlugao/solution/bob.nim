import std/strutils
proc hey*(s: string): string =
  result = ""

  if s.strip == "":
    result = "Fine. Be that way!"
  elif s == s.to_upper_ascii() and s.ends_with("?") and count(s, Letters) > 0:
    result = "Calm down, I know what I'm doing!"
  elif s == s.to_upper_ascii() and count(s, Letters) > 0:
    result = "Whoa, chill out!"
  elif s.strip.ends_with("?"):
    result= "Sure."
  else:
    result= "Whatever."
