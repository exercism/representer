import sequtils, strutils

func replyMachine(sentence: string): string =
  let phrase: string = strip(sentence)
  let yellAtHim = phrase.any(isAlphaAscii) and not phrase.any(isLowerAscii)
  let askQuestion = phrase.endswith("?")
  if phrase == "":
    "Fine. Be that way!"
  elif yellAtHim and askQuestion:
    "Calm down, I know what I'm doing!"
  elif yellAtHim:
    "Whoa, chill out!"
  elif askQuestion:
    "Sure."
  else:
    "Whatever."

func hey*(sentence: string): string = replyMachine(sentence)

# Trying out the typed template
template hey_t*(sentence: string): string = replyMachine sentence
