from itertools import cycle, chain

def placeholder_0(placeholder_1, placeholder_2):
    placeholder_3 = cycle(chain(range(placeholder_1), range(placeholder_1 - 2, 0, -1)))
    return zip(placeholder_3, range(placeholder_2))

def encode(placeholder_5, placeholder_1):
    placeholder_6 = placeholder_0(placeholder_1, len(placeholder_5))
    return ''.join((placeholder_5[placeholder_8] for _, placeholder_8 in sorted(placeholder_6)))

def decode(placeholder_5, placeholder_1):
    placeholder_6 = placeholder_0(placeholder_1, len(placeholder_5))
    placeholder_10 = zip(placeholder_5, sorted(placeholder_6))
    return ''.join((placeholder_11 for placeholder_11, _ in sorted(placeholder_10, key=lambda placeholder_13: placeholder_13[1][1])))
