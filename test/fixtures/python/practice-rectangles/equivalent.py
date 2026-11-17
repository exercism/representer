import itertools

class placeholder_0:

    def __init__(self, placeholder_2, placeholder_3):
        self.placeholder_2 = placeholder_2
        self.placeholder_3 = placeholder_3

    def __str__(self):
        return '[' + str(self.placeholder_2) + ', ' + str(self.placeholder_3) + ']'

def placeholder_5(placeholder_6, placeholder_7):
    for placeholder_8 in placeholder_7:
        if placeholder_8.placeholder_2 == placeholder_6:
            return placeholder_8
    return None

def placeholder_9(placeholder_6, placeholder_7):
    for placeholder_8 in placeholder_7:
        if placeholder_8.placeholder_3 == placeholder_6:
            return placeholder_8
    return None

def placeholder_10(placeholder_7):
    return [placeholder_0(placeholder_11, placeholder_12) for placeholder_11 in range(len(placeholder_7)) for placeholder_12 in range(len(placeholder_7[placeholder_11])) if placeholder_7[placeholder_11][placeholder_12] == '+']

def placeholder_13(placeholder_14):
    placeholder_15 = 0
    placeholder_16 = 0
    for placeholder_17 in placeholder_14:
        placeholder_15 = placeholder_15 + placeholder_17.placeholder_2 / 4.0
        placeholder_16 = placeholder_16 + placeholder_17.placeholder_3 / 4.0
    placeholder_18 = abs(placeholder_14[0].placeholder_2 - placeholder_15)
    placeholder_19 = abs(placeholder_14[0].placeholder_3 - placeholder_16)
    for placeholder_2 in range(1, len(placeholder_14)):
        if abs(placeholder_14[placeholder_2].placeholder_2 - placeholder_15) != placeholder_18 or abs(placeholder_14[placeholder_2].placeholder_3 - placeholder_16) != placeholder_19:
            return False
    return True

def placeholder_20(placeholder_21, placeholder_22, placeholder_11):
    if placeholder_21.placeholder_2 == placeholder_22.placeholder_2:
        for placeholder_3 in range(min(placeholder_21.placeholder_3 + 1, placeholder_22.placeholder_3 + 1), max(placeholder_21.placeholder_3, placeholder_22.placeholder_3)):
            if placeholder_11[placeholder_21.placeholder_2][placeholder_3] != '-' and placeholder_11[placeholder_21.placeholder_2][placeholder_3] != '+':
                return False
        return True
    elif placeholder_21.placeholder_3 == placeholder_22.placeholder_3:
        for placeholder_2 in range(min(placeholder_21.placeholder_2 + 1, placeholder_22.placeholder_2 + 1), max(placeholder_21.placeholder_2, placeholder_22.placeholder_2)):
            if placeholder_11[placeholder_2][placeholder_21.placeholder_3] != '|' and placeholder_11[placeholder_2][placeholder_21.placeholder_3] != '+':
                return False
        return True
    return None

def placeholder_23(placeholder_24, placeholder_11):
    for placeholder_2, _ in enumerate(placeholder_24):
        placeholder_26 = placeholder_5(placeholder_24[placeholder_2].placeholder_2, placeholder_24[0:placeholder_2] + placeholder_24[placeholder_2 + 1:])
        placeholder_27 = placeholder_9(placeholder_24[placeholder_2].placeholder_3, placeholder_24[0:placeholder_2] + placeholder_24[placeholder_2 + 1:])
        if not placeholder_20(placeholder_24[placeholder_2], placeholder_26, placeholder_11) or not placeholder_20(placeholder_24[placeholder_2], placeholder_27, placeholder_11):
            return False
    return True

def placeholder_28(placeholder_29=''):
    placeholder_30 = 0
    if not placeholder_29:
        return placeholder_30
    placeholder_31 = placeholder_10(placeholder_29)
    if not placeholder_31:
        return placeholder_30
    placeholder_32 = list(itertools.combinations(placeholder_31, r=4))
    placeholder_34 = (placeholder_14 for placeholder_14 in placeholder_32 if placeholder_13(placeholder_14))
    for placeholder_2 in placeholder_34:
        if placeholder_23(placeholder_2, placeholder_29):
            placeholder_30 += 1
    return placeholder_30
