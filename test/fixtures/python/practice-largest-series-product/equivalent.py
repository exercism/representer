from functools import reduce
from operator import mul

def placeholder_0(placeholder_1, placeholder_2):
    if not placeholder_2 <= len(placeholder_1):
        raise ValueError('span must be smaller than string length')
    elif not 0 < placeholder_2:
        raise ValueError('span must not be negative')
    elif not all((placeholder_3.isdigit() for placeholder_3 in placeholder_1)):
        raise ValueError('digits input must only contain digits')
    placeholder_4 = [int(placeholder_5) for placeholder_5 in placeholder_1]
    return [placeholder_4[placeholder_6:placeholder_6 + placeholder_2] for placeholder_6 in range(len(placeholder_4) - placeholder_2 + 1)]

def placeholder_7(placeholder_1, placeholder_2):
    if placeholder_2 == 0:
        return 1
    return max((reduce(mul, slice) for slice in placeholder_0(placeholder_1, placeholder_2)))
