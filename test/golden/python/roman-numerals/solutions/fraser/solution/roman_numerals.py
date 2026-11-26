ROMAN = {
    'M':1000,
    'CM':900,
    'D':500,
    'CD':400,
    'C':100,
    'XC':90,
    'L':50,
    'XL':40,
    'X':10,
    'IX':9,
    'V':5,
    'IV':4,
    'I':1,
    }

def roman(number):
    return convert(number, "")

def convert(n, output):
    for roman_numeral, value in ROMAN.items():
        if n >= value:
            output += roman_numeral
            n -= value
            break
    if n > 0:
        output = convert(n, output)
    return output