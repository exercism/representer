from itertools import count
from math import sqrt

def placeholder_0(placeholder_1):
    if placeholder_1 < 1:
        raise ValueError('there is no zeroth prime')
    placeholder_2 = []
    placeholder_3 = placeholder_9()

    def placeholder_4(placeholder_5):
        placeholder_6 = sqrt(placeholder_5)
        for placeholder_7 in placeholder_2:
            if placeholder_7 > placeholder_6:
                return True
            elif placeholder_5 % placeholder_7 == 0:
                return False
        return True
    while len(placeholder_2) < placeholder_1:
        placeholder_8 = next(placeholder_3)
        if placeholder_4(placeholder_8):
            placeholder_2.append(placeholder_8)
    return placeholder_2[placeholder_1 - 1]

def placeholder_9():
    yield 2
    yield 3
    for placeholder_1 in count(6, 6):
        yield (placeholder_1 - 1)
        yield (placeholder_1 + 1)
