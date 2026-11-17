import itertools

def combinations(placeholder_1, placeholder_2, placeholder_3):
    placeholder_4 = []
    placeholder_5 = [placeholder_6 for placeholder_6 in range(1, int((placeholder_1 ** 2 / placeholder_2) ** 0.6)) if placeholder_6 not in placeholder_3]
    if placeholder_2 == 1:
        return [[placeholder_1]]
    else:
        for placeholder_6 in range(len(placeholder_5), 0, -1):
            for placeholder_7 in itertools.combinations(placeholder_5, placeholder_6):
                if sum(placeholder_7) == placeholder_1 and len(placeholder_7) == placeholder_2:
                    placeholder_4.append(list(placeholder_7))
    return placeholder_4
