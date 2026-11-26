import std / [strutils]
  
proc hey*(s: string): string =
  let s = s.strip()  # remove leading and trailing whitespace characters

  if s == "":
    return "Fine. Be that way!"
  
  if s.toUpper() != s.toLower() and s == s.toUpper():    # s does contain letters, all of which are capital
    if s.endsWith('?'):
      return "Calm down, I know what I'm doing!"
    else:
      return  "Whoa, chill out!"
  else:
    if s.endsWith('?'):
      return "Sure."
    else:
      return  "Whatever."
    