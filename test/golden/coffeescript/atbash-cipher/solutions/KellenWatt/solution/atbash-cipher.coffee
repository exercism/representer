
charIndex = (c) ->
    c.charCodeAt(0) - 97

indexChar = (i) ->
    String.fromCharCode(i + 97)

isLetter = (c) ->
    c = c.charCodeAt(0)
    (97 <= c < 123) or (65 <= c < 91)

isNumber = (c) ->
    48 <= c.charCodeAt(0) < 58

isAlnum = (c) -> isLetter(c) or isNumber(c)

alphaSwap = (c) ->
    if isLetter(c)
        indexChar(25 - charIndex(c))
    else
        c

mirror = (str) -> (alphaSwap(c) for c in str.toLowerCase() when isAlnum(c))
        
class AtbashCipher
  @encode: (phrase) ->
    encoding = mirror(phrase)
    slices = Math.ceil(encoding.length / 5)
    (encoding.slice(5*i, 5*i+5).join("") for i in [0...slices]).join(" ")

  @decode: (phrase) ->
    mirror(phrase).join("")

module.exports = AtbashCipher
