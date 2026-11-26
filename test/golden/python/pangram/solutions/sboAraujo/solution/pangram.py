def is_pangram(sentence):
    aString = 'abcdefghijklmnopqrstuvwxyz'
    for i in aString:
        if i in sentence.casefold():
            ans = True
        else:
            ans = False
            break
    return ans
