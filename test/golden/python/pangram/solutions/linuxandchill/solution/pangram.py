def is_pangram(sentence):
    alphabet = "abcdefghijklmnopqrstuvwxyz"

    #loop through letters 
    for l in alphabet: 
        #check if letter is in input sentence
        if l not in sentence.lower():
            return False

    return True