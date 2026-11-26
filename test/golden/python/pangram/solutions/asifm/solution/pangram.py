def is_pangram(sentence):
    sentence = set(sentence.lower())
    alphabet = "abcdefghijklmnopqrstuvwxyz"
    return all(char in sentence for char in alphabet)