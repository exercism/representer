placeholder_0 = 4
placeholder_1 = 3

def placeholder_2(placeholder_3):
    return [[placeholder_3[placeholder_4][placeholder_1 * placeholder_5:placeholder_1 * (placeholder_5 + 1)] for placeholder_4 in range(placeholder_0)] for placeholder_5 in range(len(placeholder_3[0]) // placeholder_1)]
placeholder_7 = ['    _  _     _  _  _  _  _  _ ', '  | _| _||_||_ |_   ||_||_|| |', '  ||_  _|  | _||_|  ||_| _||_|', '                              ']
placeholder_8 = placeholder_2(placeholder_7)
placeholder_8 = [placeholder_8[-1]] + placeholder_8[:9]

def placeholder_9(placeholder_10):
    placeholder_11 = list(range(0, len(placeholder_10), placeholder_0)) + [len(placeholder_10)]
    placeholder_12 = [placeholder_10[placeholder_13:placeholder_14] for placeholder_13, placeholder_14 in zip(placeholder_11[:-1], placeholder_11[1:])]
    return ','.join((placeholder_16(placeholder_15) for placeholder_15 in placeholder_12))

def placeholder_16(placeholder_10):
    if len(placeholder_10) != placeholder_0:
        raise ValueError('Number of input lines is not a multiple of four')
    if len(placeholder_10[0]) % placeholder_1:
        raise ValueError('Number of input columns is not a multiple of three')
    placeholder_17 = placeholder_2(placeholder_10)
    placeholder_18 = ''
    for placeholder_19 in placeholder_17:
        try:
            placeholder_18 += str(placeholder_8.index(placeholder_19))
        except ValueError:
            placeholder_18 += '?'
    return placeholder_18
