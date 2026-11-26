ALPHABET = 'abcdefghijklmnopqrstuvwxyz'

def rotate(text, key):
    outtab = ALPHABET[key:] + ALPHABET[:key]
    trans = str.maketrans(ALPHABET + ALPHABET.upper(), outtab + outtab.upper())

    return text.translate(trans)