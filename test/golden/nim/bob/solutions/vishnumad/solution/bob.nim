import strutils
import sequtils

const lowercase = {'a'..'z'}

proc hey*(phrase: string): string =
    let phrase = phrase.strip
    if phrase.len == 0: return "Fine. Be that way!"

    let filtered = phrase.filter(isAlphaAscii).join
    let question = phrase.endsWith('?')
    let shouting = filtered.len > 0 and filtered.count(lowercase) == 0

    if question and not shouting:
        return "Sure."
    elif not question and shouting:
        return "Whoa, chill out!"
    elif question and shouting:
        return "Calm down, I know what I'm doing!"
    else:
        return "Whatever."