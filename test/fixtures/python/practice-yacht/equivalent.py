from collections import Counter
from functools import partial
placeholder_0 = 0
placeholder_1 = 1
placeholder_2 = 2
placeholder_3 = 3
placeholder_4 = 4
placeholder_5 = 5
placeholder_6 = 6
placeholder_7 = 7
placeholder_8 = 8
placeholder_9 = 9
placeholder_10 = 10
placeholder_11 = 11

def placeholder_12(placeholder_13, placeholder_14):
    return sum((placeholder_15 for placeholder_15 in placeholder_14 if placeholder_15 == placeholder_13))

def placeholder_16(placeholder_14):
    placeholder_17 = Counter(placeholder_14)
    return sum(placeholder_14) if set(placeholder_17.values()) == {3, 2} else 0

def placeholder_18(placeholder_14):
    placeholder_17 = Counter(placeholder_14)
    placeholder_13, placeholder_19 = placeholder_17.most_common()[0]
    return 4 * placeholder_13 if placeholder_19 >= 4 else 0

def placeholder_20(placeholder_14):
    return 30 if set(placeholder_14) == {1, 2, 3, 4, 5} else 0

def placeholder_21(placeholder_14):
    return 30 if set(placeholder_14) == {2, 3, 4, 5, 6} else 0

def placeholder_22(placeholder_14):
    return 50 if len(set(placeholder_14)) == 1 else 0
placeholder_23 = [placeholder_22, partial(placeholder_12, 1), partial(placeholder_12, 2), partial(placeholder_12, 3), partial(placeholder_12, 4), partial(placeholder_12, 5), partial(placeholder_12, 6), placeholder_16, placeholder_18, placeholder_20, placeholder_21, sum]

def placeholder_24(placeholder_14, placeholder_25):
    try:
        return placeholder_23[placeholder_25](placeholder_14)
    except IndexError as placeholder_26:
        raise ValueError('No such category.') from placeholder_26
