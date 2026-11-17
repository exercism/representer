def placeholder_0(placeholder_1):
    if not placeholder_1:
        return []
    placeholder_11(placeholder_1)
    placeholder_2 = len(placeholder_1[0])
    placeholder_3 = len(placeholder_1)
    placeholder_4 = [list(placeholder_5) for placeholder_5 in placeholder_1]
    for placeholder_6 in range(placeholder_3):
        for placeholder_7 in range(placeholder_2):
            if placeholder_4[placeholder_6][placeholder_7] != ' ':
                continue
            placeholder_8 = max(placeholder_7 - 1, 0)
            placeholder_9 = min(placeholder_7 + 2, placeholder_2 + 2)
            placeholder_10 = placeholder_1[placeholder_6][placeholder_8:placeholder_9].count('*')
            if placeholder_6 > 0:
                placeholder_10 += placeholder_1[placeholder_6 - 1][placeholder_8:placeholder_9].count('*')
            if placeholder_6 < placeholder_3 - 1:
                placeholder_10 += placeholder_1[placeholder_6 + 1][placeholder_8:placeholder_9].count('*')
            if placeholder_10 == 0:
                continue
            placeholder_4[placeholder_6][placeholder_7] = str(placeholder_10)
    return [''.join(placeholder_5) for placeholder_5 in placeholder_4]

def placeholder_11(placeholder_1):
    placeholder_2 = len(placeholder_1[0])
    if not all((len(placeholder_5) == placeholder_2 for placeholder_5 in placeholder_1)):
        raise ValueError('The board is invalid with current input.')
    placeholder_12 = set()
    for placeholder_5 in placeholder_1:
        placeholder_12.update(placeholder_5)
    if placeholder_12 - set(' *'):
        raise ValueError('The board is invalid with current input.')
