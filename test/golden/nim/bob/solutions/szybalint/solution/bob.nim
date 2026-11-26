import std/strutils

proc hey*(message: string): string =
    # if you don't say anything, he will answer "Fine. Be that way!"
    if message.isEmptyOrWhitespace(): return "Fine. Be that way!"

    const
        yell = 1
        question = 2
        weird = 4
    var messageType = 0

    if message == message.toUpper(): messageType += yell
    if messageType == yell and message == message.toLower(): messageType += weird
    if message.strip()[^1] == '?': messageType += question

    result = case messageType:
        # if you ask him a question, he will answer "Sure."
        of question, question + yell + weird: "Sure."
        # if you yell at him, he will answer "Whoa, chill out!"
        of yell: "Whoa, chill out!"
        # if you yell a question at him, he will answer "Calm down, I know what I'm doing!"
        of yell + question: "Calm down, I know what I'm doing!"
        # he will answer "Whatever." to anything else
        else: "Whatever."
