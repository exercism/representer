import strutils, sequtils


proc isShouting(sentence:string): bool = 
    sentence.contains({'A'..'Z'}) and not sentence.contains({'a'..'z'})

proc isQuestion(sentence:string): bool =
    sentence.strip.endsWith('?')
    
proc isSilence(sentence:string): bool = 
    sentence.allIt(isEmptyOrWhitespace($it))


proc hey*(sentence:string): string=
    if sentence.isShouting and sentence.isQuestion:
        return "Calm down, I know what I'm doing!"
    elif sentence.isShouting:
        return "Whoa, chill out!"
    elif sentence.isQuestion:
        return "Sure."
    elif sentence.isSilence:
        return "Fine. Be that way!"
    else:
        return "Whatever."