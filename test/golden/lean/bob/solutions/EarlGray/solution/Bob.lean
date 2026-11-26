namespace Bob

def response (heyBob : String) : String := Id.run do
  let mut lastNonspace : Char := ' '
  let mut anyLower : Bool := false
  let mut anyUpper : Bool := false
  for c in heyBob.chars do
    if !c.isWhitespace then lastNonspace := c
    if c.isUpper then anyUpper := true
    else if c.isLower then anyLower := true

  if ' ' == lastNonspace then   -- silence?
    return "Fine. Be that way!"
  match (
    /-question?-/ '?' == lastNonspace,
    /-shouting?-/ anyUpper && !anyLower
  ) with
  | (true, true)    => "Calm down, I know what I'm doing!" 
  | (true, false)   => "Sure."
  | (false, true)   => "Whoa, chill out!"
  | (false, false)  => "Whatever."
     
end Bob
