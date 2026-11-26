def is_pangram(sentence):
    sentence = set(sentence.lower())
    alphabet = "abcdefghijklmoopqrstuvwxyz"
    return all(char in sentence for char in alphabet)