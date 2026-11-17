"""Why won't this damn thing work?!!"""
placeholder_0 = 5
placeholder_1 = 26

def placeholder_2(placeholder_3, placeholder_4):
    placeholder_3 = placeholder_3 % placeholder_4
    for placeholder_5 in range(1, placeholder_4):
        if placeholder_3 * placeholder_5 % placeholder_4 == 1:
            return placeholder_5
    return 1

def translate(placeholder_7, placeholder_3, placeholder_8, placeholder_9):
    placeholder_10 = placeholder_2(placeholder_3, placeholder_1)
    if placeholder_10 == 1:
        raise ValueError('a and m must be coprime.')
    placeholder_11 = []
    for placeholder_12 in placeholder_7:
        if placeholder_12.isalnum():
            placeholder_13 = ord(placeholder_12.lower()) - 97
            if placeholder_13 < 0:
                placeholder_11.append(placeholder_12)
                continue
            if placeholder_9 == 0:
                placeholder_14 = (placeholder_3 * placeholder_13 + placeholder_8) % placeholder_1
            elif placeholder_9 == 1:
                placeholder_14 = placeholder_10 * (placeholder_13 - placeholder_8) % placeholder_1
            placeholder_11.append(chr(placeholder_14 + 97))
    return ''.join(placeholder_11)

def encode(placeholder_16, placeholder_17, placeholder_18):
    placeholder_19 = translate(placeholder_16, placeholder_17, placeholder_18, 0)
    return ' '.join([placeholder_19[placeholder_5:placeholder_5 + placeholder_0] for placeholder_5 in range(0, len(placeholder_19), placeholder_0)])

def decode(placeholder_21, placeholder_17, placeholder_18):
    return translate(placeholder_21, placeholder_17, placeholder_18, 1)
