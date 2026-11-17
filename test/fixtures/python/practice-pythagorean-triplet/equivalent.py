from math import sqrt, ceil, gcd

def placeholder_0(placeholder_1, placeholder_2):
    for placeholder_3 in range(4, placeholder_2 + 1, 4):
        for placeholder_4, placeholder_5, placeholder_6 in placeholder_14(placeholder_3):
            placeholder_7 = placeholder_4
            placeholder_8 = placeholder_5
            placeholder_9 = placeholder_6
            while placeholder_7 < placeholder_1:
                placeholder_7 = placeholder_7 + placeholder_4
                placeholder_8 = placeholder_8 + placeholder_5
                placeholder_9 = placeholder_9 + placeholder_6
            while placeholder_9 <= placeholder_2:
                yield [placeholder_7, placeholder_8, placeholder_9]
                placeholder_7 = placeholder_7 + placeholder_4
                placeholder_8 = placeholder_8 + placeholder_5
                placeholder_9 = placeholder_9 + placeholder_6

def placeholder_10(placeholder_3):
    placeholder_11 = placeholder_3 // 2
    for placeholder_12 in range(1, int(ceil(sqrt(placeholder_11)))):
        if placeholder_11 % placeholder_12 == 0:
            placeholder_13 = placeholder_11 // placeholder_12
            if (placeholder_13 - placeholder_12) % 2 == 1 and gcd(placeholder_13, placeholder_12) == 1:
                yield (placeholder_13, placeholder_12)

def placeholder_14(placeholder_3):
    """See Euclid's formula
    (https://en.wikipedia.org/wiki/Pythagorean_triple#Generating_a_triple)
    for more information
    """
    for placeholder_15, placeholder_16 in placeholder_10(placeholder_3):
        placeholder_17 = placeholder_15 ** 2
        placeholder_18 = placeholder_16 ** 2
        placeholder_7 = placeholder_17 - placeholder_18
        placeholder_8 = 2 * placeholder_15 * placeholder_16
        placeholder_9 = placeholder_17 + placeholder_18
        if placeholder_7 > placeholder_8:
            placeholder_7, placeholder_8 = (placeholder_8, placeholder_7)
        yield (placeholder_7, placeholder_8, placeholder_9)

def placeholder_19(placeholder_20):
    return [placeholder_21 for placeholder_21 in placeholder_0(1, placeholder_20 // 2) if sum(placeholder_21) == placeholder_20]
