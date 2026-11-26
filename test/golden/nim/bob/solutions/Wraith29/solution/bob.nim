import sugar, strutils, sequtils

proc isYelling(inp: string): bool =
    let chars = collect(newSeq):
        for c in inp:
            if isAlphaAscii(c):
                c
    all(chars, c => isUpperAscii(c)) and chars.len != 0

proc hey*(inp: string): string =
    if inp.strip == "":
        return "Fine. Be that way!"

    if inp.strip[^1] == '?':
        if inp.isYelling:
            return "Calm down, I know what I'm doing!"
        else:
            return "Sure."

    if inp.strip.isYelling:
        return "Whoa, chill out!"

    return "Whatever."
