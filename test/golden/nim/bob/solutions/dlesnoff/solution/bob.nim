import std/strutils
proc hey*(address: string): string =
  var
    shout: bool = true
    letters: bool = false
  for c in address:
    if c.isAlphaAscii:
      if c in {'a'..'z'}:
        shout = false
      letters = true
  if not letters:
    shout = false
  result = "Whatever."
  if address.strip  == "":
    result = "Fine. Be that way!"
  if address.strip.endswith('?') and not shout:
    result = "Sure."
  if not address.strip.endswith('?') and shout :
    result = "Whoa, chill out!"
  if address.strip.endswith('?') and shout :
    result = """Calm down, I know what I'm doing!"""
