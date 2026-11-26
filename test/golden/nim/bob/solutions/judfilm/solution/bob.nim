import strutils


proc hey*(msg: string): string =

    if msg.isEmptyOrWhitespace:
        "Fine. Be that way!"
    elif msg == msg.toUpperAscii and msg != msg.toLowerAscii and msg.endsWith '?':
        "Calm down, I know what I'm doing!"
    elif msg == msg.toUpperAscii and msg != msg.toLowerAscii:
        "Whoa, chill out!"
    elif msg.strip.endsWith '?':
        "Sure."
    else:
        "Whatever."