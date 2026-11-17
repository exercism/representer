from math import ceil, sqrt
from itertools import zip_longest

def placeholder_0(placeholder_1):
    placeholder_1 = placeholder_6(placeholder_1)
    placeholder_2 = int(ceil(sqrt(len(placeholder_1))))
    placeholder_3 = placeholder_9(placeholder_1, placeholder_2)
    return ' '.join([''.join(placeholder_4) for placeholder_4 in zip_longest(*placeholder_3, fillvalue=' ')])

def placeholder_6(placeholder_7):
    """Lowercase a string and remove punctuation and whitespace
    """
    return ''.join([placeholder_8 for placeholder_8 in placeholder_7 if placeholder_8.isalnum()]).lower()

def placeholder_9(placeholder_7, placeholder_10):
    if len(placeholder_7) <= placeholder_10:
        return [placeholder_7]
    return [placeholder_7[:placeholder_10]] + placeholder_9(placeholder_7[placeholder_10:], placeholder_10)
