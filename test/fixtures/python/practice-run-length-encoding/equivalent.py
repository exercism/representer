from itertools import groupby
from re import sub

def decode(placeholder_1):
    return sub('(\\d+)(\\D)', lambda placeholder_2: placeholder_2.group(2) * int(placeholder_2.group(1)), placeholder_1)

def encode(placeholder_1):

    def placeholder_4(placeholder_5, placeholder_6):
        placeholder_7 = len(list(placeholder_6))
        return placeholder_5 if placeholder_7 == 1 else str(placeholder_7) + placeholder_5
    return ''.join((placeholder_4(placeholder_5, placeholder_6) for placeholder_5, placeholder_6 in groupby(placeholder_1)))
