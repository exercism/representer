def placeholder_0(placeholder_1, placeholder_2, placeholder_3):
    if '-i' in placeholder_3:
        placeholder_1 = placeholder_1.lower()
        placeholder_2 = placeholder_2.lower()
    if '-x' in placeholder_3:
        if len(placeholder_2) != len(placeholder_1.rstrip()):
            return '-v' in placeholder_3
    if '-v' in placeholder_3:
        return placeholder_2 not in placeholder_1
    return placeholder_2 in placeholder_1

def placeholder_4(placeholder_5):
    placeholder_6 = ''
    for placeholder_7, _, _ in placeholder_5:
        if placeholder_7 not in placeholder_6:
            placeholder_6 += placeholder_7 + '\n'
    return placeholder_6

def placeholder_9(placeholder_5, placeholder_3, placeholder_10):
    placeholder_6 = []
    for placeholder_7, placeholder_11, placeholder_1 in placeholder_5:
        placeholder_12 = ''
        if len(placeholder_10) > 1:
            placeholder_12 += placeholder_7 + ':'
        if '-n' in placeholder_3:
            placeholder_12 += str(placeholder_11) + ':'
        placeholder_12 += placeholder_1
        placeholder_6.append(placeholder_12)
    return ''.join(placeholder_6)

def placeholder_13(placeholder_2, placeholder_3, placeholder_10):
    placeholder_5 = []
    for placeholder_7 in placeholder_10:
        with open(placeholder_7, encoding='utf-8') as placeholder_15:
            for placeholder_11, placeholder_1 in enumerate(placeholder_15.readlines(), start=1):
                if placeholder_0(placeholder_1, placeholder_2, placeholder_3):
                    placeholder_5.append((placeholder_7, placeholder_11, placeholder_1))
    if '-l' in placeholder_3:
        return placeholder_4(placeholder_5)
    return placeholder_9(placeholder_5, placeholder_3, placeholder_10)
