VOVELS = ['a', 'e', 'i', 'o', 'u']
SUFFIX = 'ay'

def translate(text):
    words = str(text).strip().lower().split()
    return ' '.join([mutate(word) for word in words])

def moving_group(word):
    res = ''
    for ch in word:
        if ch == 'u' and res[-1] == 'q':
            res += ch
            break
        if ch in VOVELS or (ch == 'y' and len(res)):
            break
        if ch not in VOVELS:
            res += ch
    return res

def mutate(word):
    if len(word) < 2:
        return word
    if word[0] in VOVELS or word[:2] in ["xr", "yt"]:
        return word + SUFFIX
    mg = moving_group(word)
    return word[len(mg):] + mg + SUFFIX