import std/strutils
import std/re

proc isAskingQuestion(phrase: string): bool =
  phrase.strip.endsWith("?")

proc isShouting(phrase: string): bool =
  contains(phrase, re"[A-Z]+") and not contains(phrase, re"[a-z]+")

proc hey*(phrase: string): string =
  if phrase.isAskingQuestion:
    if phrase.isShouting:
      return "Calm down, I know what I'm doing!"
    else:
      return "Sure."
  elif phrase.isEmptyOrWhitespace:
    return "Fine. Be that way!"
  elif phrase.isShouting:
    return "Whoa, chill out!"
  else:
    return "Whatever."