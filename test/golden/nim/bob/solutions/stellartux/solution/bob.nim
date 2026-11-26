import std/strutils
  
proc hey*(s: string): string =
  ## Bob is a cool guy
  let
    is_yelling = s.contains({ 'A'..'Z' }) and not s.contains({ 'a'..'z' })
    is_question = s.strip.ends_with('?')
  if is_yelling and is_question:
    "Calm down, I know what I'm doing!"    
  elif is_yelling:
    "Whoa, chill out!"
  elif is_question:
    "Sure."
  elif all_chars_in_set(s, Whitespace):
    "Fine. Be that way!"
  else:
    "Whatever."
