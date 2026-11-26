import strutils, sequtils

proc isSayingNothing(str: string): bool =
    str.filter(isAlphaNumeric).len == 0

proc isQuestion(str: string): bool =
    str.endsWith('?')

proc isYelling(str: string): bool =
    let letters = str.filter(isAlphaAscii)
    letters.len > 0 and all(letters, isUpperAscii) 

proc hey*(str: string): string =
    let cleanedStr = str.strip
    if cleanedStr.isQuestion:
        if cleanedStr.isYelling:
            return "Calm down, I know what I'm doing!"
        return "Sure."
    if cleanedStr.isSayingNothing:
        return "Fine. Be that way!"
    if cleanedStr.isYelling:
        return "Whoa, chill out!"
    "Whatever."