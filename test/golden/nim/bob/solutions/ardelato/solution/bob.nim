import strutils
  
proc isQuestion(message:string): bool =
  message.endsWith('?')

proc isShouting(message:string): bool =
  message.contains(Letters) and message.toUpperAscii() == message

proc hey*(message: string): string =
  var stripped_message = message.strip()

  if stripped_message == "":
    return "Fine. Be that way!"
  if stripped_message.isQuestion() and stripped_message.isShouting():
    return "Calm down, I know what I'm doing!"
  elif stripped_message.isQuestion():
    return "Sure."
  elif stripped_message.isShouting():
    return "Whoa, chill out!"
  else:
    return "Whatever."