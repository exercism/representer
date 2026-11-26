import std/strutils
import std/sequtils
  
proc hey*(statement: string): string =
  let statement = statement.strip
  if statement.isEmptyOrWhitespace:
    return "Fine. Be that way!"
  if statement == toUpperAscii(statement) and any(statement, isAlphaAscii):
    if statement.endsWith('?'):
      return "Calm down, I know what I'm doing!"
    else:
      return "Whoa, chill out!"
  if statement.endsWith('?'):
      return "Sure."

  return "Whatever."