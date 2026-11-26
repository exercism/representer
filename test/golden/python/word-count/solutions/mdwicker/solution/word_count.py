import re

def count_words(sentence):
    # extracts words with optional internal apostrophes
    words = re.findall(r'[a-zA-Z0-9]+(?:\'?[a-zA-Z0-9]+)?', sentence)

    word_count = {}

    for word in words:
        word_lower = word.lower()
        word_count[word_lower] = word_count.get(word_lower, 0) + 1

    return word_count
