"""Functions to help edit essay homework using string manipulation."""

def placeholder_0(placeholder_1):
    """Convert the first letter of each word in the title to uppercase if needed.

    :param title: str - title string that needs title casing.
    :return: str - title string in title case (first letters capitalized).
    """
    return placeholder_1.title()

def placeholder_2(placeholder_3):
    """Check the ending of the sentence to verify that a period is present.

    :param sentence: str - a sentence to check.
    :return: bool - is the sentence punctuated correctly?
    """
    return placeholder_3.endswith('.')

def placeholder_4(placeholder_3):
    """Trim any leading or trailing whitespace from the sentence.

    :param sentence: str - a sentence to clean of leading and trailing space characters.
    :return: str - a sentence that has been cleaned of leading and trailing space characters.
    """
    placeholder_5 = placeholder_3.strip()
    return placeholder_5

def placeholder_6(placeholder_3, placeholder_7, placeholder_8):
    """Replace a word in the provided sentence with a new one.

    :param sentence: str - a sentence to replace words in.
    :param old_word: str - word to replace.
    :param new_word: str - replacement word.
    :return: str - input sentence with new words in place of old words.
    """
    placeholder_9 = placeholder_3.replace(placeholder_7, placeholder_8)
    return placeholder_9
