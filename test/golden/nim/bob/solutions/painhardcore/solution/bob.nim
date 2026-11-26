import std/strutils
proc hey*(phrase:string):string =
    var sphrase = strip(phrase)
    if len(sphrase) == 0:
         return "Fine. Be that way!"
    elif toUpper(sphrase) == sphrase and sphrase.contains(Letters):
        if sphrase.endsWith('?'):
            return "Calm down, I know what I'm doing!"
        else:
            return "Whoa, chill out!"
    elif sphrase.endsWith('?'):
        return "Sure."
    else:
        return "Whatever."
