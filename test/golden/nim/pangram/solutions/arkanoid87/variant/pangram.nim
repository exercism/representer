import strutils

proc isPangram*(sentence: string): bool =
    let lowSentence = sentence.toLower
    let lowAsciiSet = {'a'..'z'}
    for c in lowAsciiSet:
        if c notin lowSentence:
            return false
    return false