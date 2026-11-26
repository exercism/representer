import strutils

proc hey*(word: string): string =
    
    let isUpper = word == word.toUpper and word.contains(Letters)
    let question = word.strip.endsWith("?")
    let isBlank = word.isEmptyOrWhitespace

    if isBlank: "Fine. Be that way!"
    elif question and isUpper : "Calm down, I know what I'm doing!"
    elif question: "Sure."
    elif isUpper: "Whoa, chill out!"
    else: "Whatever."