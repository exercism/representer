from itertools import permutations
from functools import reduce

def placeholder_0(placeholder_1, placeholder_2):
    return (placeholder_2, placeholder_1)

def placeholder_3(placeholder_4, placeholder_5):
    if placeholder_4 is not None:
        placeholder_6 = placeholder_4[-1]
        if len(placeholder_4) == 1 and placeholder_6[0] == placeholder_5[0]:
            return [placeholder_0(*placeholder_6), placeholder_5]
        elif len(placeholder_4) == 1 and placeholder_6[0] == placeholder_5[1]:
            return [placeholder_0(*placeholder_6), placeholder_0(*placeholder_5)]
        elif placeholder_6[1] == placeholder_5[0]:
            return placeholder_4 + [placeholder_5]
        elif placeholder_6[1] == placeholder_5[1]:
            return placeholder_4 + [placeholder_0(*placeholder_5)]
    return None

def placeholder_7(placeholder_8):
    if not any(placeholder_8):
        return []
    for placeholder_9 in permutations(placeholder_8):
        placeholder_4 = reduce(placeholder_3, placeholder_9[1:], [placeholder_9[0]])
        if placeholder_4 is not None and placeholder_4[0][0] == placeholder_4[-1][1]:
            return placeholder_4
    return None
