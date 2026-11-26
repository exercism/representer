import strutils

proc is_all_caps(s: string): bool =
  for c in s:
    if c.isAlphaAscii() and not c.isUpperAscii():
      return false
  return true

proc has_letters(s: string): bool =
  for c in s:
    if c.isAlphaAscii:
      return true
  
proc hey*(s: string): string =
  let s = s.strip;

  if s.len == 0:
    return "Fine. Be that way!"
  elif s[^1] == '?' and s.has_letters and s.is_all_caps:
    return "Calm down, I know what I'm doing!"
  elif s[^1] == '?':
    return "Sure."  
  elif s.is_all_caps and s.has_letters:
    return "Whoa, chill out!"
  else:
    return "Whatever."
  