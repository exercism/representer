placeholder_0 = 128
placeholder_1 = 127

def placeholder_2(placeholder_3):
    placeholder_4 = [placeholder_3 & placeholder_1]
    placeholder_3 >>= 7
    while placeholder_3 > 0:
        placeholder_4.append(placeholder_3 & placeholder_1 | placeholder_0)
        placeholder_3 >>= 7
    return placeholder_4[::-1]

def encode(placeholder_6):
    return sum((placeholder_2(placeholder_3) for placeholder_3 in placeholder_6), [])

def decode(placeholder_4):
    placeholder_8 = []
    placeholder_3 = 0
    for placeholder_9, placeholder_10 in enumerate(placeholder_4):
        placeholder_3 <<= 7
        placeholder_3 += placeholder_10 & placeholder_1
        if placeholder_10 & placeholder_0 == 0:
            placeholder_8.append(placeholder_3)
            placeholder_3 = 0
        elif placeholder_9 == len(placeholder_4) - 1:
            raise ValueError('incomplete sequence')
    return placeholder_8
