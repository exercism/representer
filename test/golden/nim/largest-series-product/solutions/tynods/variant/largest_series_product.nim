import std/math
import std/strutils

proc getDigits(s: string) : seq[int] =
    for c in s :
        result.add(parseInt($c))

proc largestProduct*(s: string, span: int): int =
    if s.len==0 : raise newException(ValueError, "empty input")
    if span>s.len : raise newException(ValueError, "span longer than input")
    if span<=0 : raise newException(ValueError, "invalid span")
    var curProd = 0
    for i in 0..len(s)-span :
        let p = prod(getDigits(s[i..(i-span-1)]))
        if p>curProd : curProd = p

    return curProd

