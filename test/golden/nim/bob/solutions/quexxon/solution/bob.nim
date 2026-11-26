import std/strutils

func isShouting(remark: string): bool =
    result = false
    for c in remark:
        if c.isAlphaAscii:
            if c.isUpperAscii:
                result = true
            else:
                result = false
                break

func hey*(remark: string): string =
    let remark = remark.strip
    if remark.endsWith('?'):
        if remark.isShouting:
            "Calm down, I know what I'm doing!"
        else:
            "Sure."
    elif remark.isShouting:
        "Whoa, chill out!"
    elif remark.isEmptyOrWhitespace:
        "Fine. Be that way!"
    else:
        "Whatever."