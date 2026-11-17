def placeholder_0(placeholder_1, placeholder_2):
    return sum((placeholder_4 * placeholder_2 ** placeholder_3 for placeholder_3, placeholder_4 in enumerate(reversed(placeholder_1))))

def placeholder_5(placeholder_4, placeholder_6):
    placeholder_7 = []
    while placeholder_4 > 0:
        placeholder_7.append(placeholder_4 % placeholder_6)
        placeholder_4 //= placeholder_6
    if placeholder_7:
        return placeholder_7[::-1]
    return [0]

def placeholder_8(placeholder_9, placeholder_1, placeholder_10):
    if placeholder_9 < 2:
        raise ValueError('input base must be >= 2')
    if placeholder_10 < 2:
        raise ValueError('output base must be >= 2')
    if any((True for placeholder_3 in placeholder_1 if placeholder_3 < 0 or placeholder_3 >= placeholder_9)):
        raise ValueError('all digits must satisfy 0 <= d < input base')
    return placeholder_5(placeholder_0(placeholder_1, placeholder_9), placeholder_10)
