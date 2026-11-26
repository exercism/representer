import strutils

let lowerLetters = {'a'..'z'}
let capsLetters = {'A'..'Z'}

proc hey* (phrase: string): string =
  let text = phrase.strip

  if text.len == 0:
    return "Fine. Be that way!"

  let isQuestion = text[text.len-1] == '?'
  var isYelling = false
  var isNotYelling = false
  for sym in text:
    if capsLetters.contains(sym) and not isNotYelling:
      isYelling = true
    elif lowerLetters.contains(sym):
      isNotYelling = true
      isYelling = false

  if isQuestion:
    if isYelling:
      "Calm down, I know what I'm doing!"
    else:
      "Sure."
  else:
    if isYelling:
      "Whoa, chill out!"
    else:
      "Whatever."