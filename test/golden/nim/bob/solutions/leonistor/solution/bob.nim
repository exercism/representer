import strutils

proc isShouted(s: string): bool =
  s.toUpper == s and s.contains(Letters)

proc isQuestion(s: string): bool =
  s.endsWith('?')

proc hey*(input: string): string =
  let remark = input.strip
  result =
    if remark.isEmptyOrWhitespace:
      "Fine. Be that way!"
    elif remark.isShouted and remark.isQuestion:
      "Calm down, I know what I'm doing!"
    elif remark.isShouted:
      "Whoa, chill out!"
    elif remark.isQuestion:
      "Sure."
    else:
      "Whatever."
