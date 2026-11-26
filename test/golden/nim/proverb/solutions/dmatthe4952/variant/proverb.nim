proc recite*(words: openArray[string]): string =
  if len(words) == 0:
    return
  var outString : string = ""
  if len(words) >= 1:
    for x in 0 .. len(words) - 2:
      outString &= "For want of a " & words[x] & " the " & words[x + 1] & " was lost.\n"  
  outString &= "And all for the want of a " & words[0] & "."
  discard

  result = outString
