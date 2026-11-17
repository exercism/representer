"""Functions for creating, transforming, and adding prefixes to strings."""

def placeholder_0(placeholder_1):
    """Take the given word and add the 'un' prefix.

    :param word: str - containing the root word.
    :return: str - of root word prepended with 'un'.
    """
    return 'un' + placeholder_1

def placeholder_2(placeholder_3):
    """Transform a list containing a prefix and words into a string with the prefix followed by the words with prefix prepended.

    :param vocab_words: list - of vocabulary words with prefix in first index.
    :return: str - of prefix followed by vocabulary words with
            prefix applied.

    This function takes a `vocab_words` list and returns a string
    with the prefix and the words with prefix applied, separated
     by ' :: '.

    For example: list('en', 'close', 'joy', 'lighten'),
    produces the following string: 'en :: enclose :: enjoy :: enlighten'.
    """
    placeholder_4 = placeholder_3[0]
    placeholder_5 = ' :: ' + placeholder_4
    return placeholder_5.join(placeholder_3)

def placeholder_6(placeholder_1):
    """Remove the suffix from the word while keeping spelling in mind.

    :param word: str - of word to remove suffix from.
    :return: str - of word with suffix removed & spelling adjusted.

    For example: "heaviness" becomes "heavy", but "sadness" becomes "sad".
    """
    placeholder_1 = placeholder_1[:-4]
    if placeholder_1[-1] == 'i':
        placeholder_1 = placeholder_1[:-1] + 'y'
    return placeholder_1

def placeholder_7(placeholder_8, placeholder_9):
    """Change the adjective within the sentence to a verb.

    :param sentence: str - that uses the word in sentence.
    :param index: int - index of the word to remove and transform.
    :return: str - word that changes the extracted adjective to a verb.

    For example, ("It got dark as the sun set", 2) becomes "darken".
    """
    placeholder_1 = placeholder_8.split()[placeholder_9]
    if placeholder_1[-1] == '.':
        placeholder_1 = placeholder_1[:-1] + 'en'
    else:
        placeholder_1 = placeholder_1 + 'en'
    return placeholder_1
