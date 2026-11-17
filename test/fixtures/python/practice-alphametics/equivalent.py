"""
This solution will first parse the alphametic expression
grouping and counting letters buy digit ranks
then trace recursively all possible permutations starting from
the lowest rank and genrating additional permutations for new digits
at higer ranks as necessary.
This will allow to avoid unnecessarily large permutations to scan.
Also leading letters in words will be treated as non-zero digits only
to reduce the number of permutations
"""
from itertools import permutations, chain, product

def placeholder_0(placeholder_1, placeholder_2, placeholder_3):
    """This function creates permutations given the set of digits,
       letters not alllowed to be 0, and letters allowed to be 0
    """
    placeholder_4 = len(placeholder_2)
    placeholder_5 = len(placeholder_3)
    placeholder_6 = placeholder_4 + placeholder_5
    if placeholder_6 < 1:
        return [()]
    placeholder_7 = placeholder_1 - set((0,))
    placeholder_8 = len(placeholder_7)
    placeholder_9 = len(placeholder_1)
    if placeholder_9 < placeholder_6 or placeholder_8 < placeholder_4:
        return []
    elif placeholder_4 == 0 or placeholder_9 == placeholder_8:
        return permutations(placeholder_1, placeholder_6)
    elif placeholder_5 == 0:
        return permutations(placeholder_7, placeholder_6)
    else:
        placeholder_10 = list(range(placeholder_4, placeholder_6))
        return chain(permutations(placeholder_7, placeholder_6), map(lambda placeholder_11: placeholder_11[0][:placeholder_11[1]] + (0,) + placeholder_11[0][placeholder_11[1]:], product(permutations(placeholder_7, placeholder_6 - 1), placeholder_10)))

def placeholder_12(placeholder_13, placeholder_14=({}, 0, set(range(10))), placeholder_15=0):
    """This function recursively traces a parsed expression from lowest
       digits to highest, generating additional digits when necessary
       checking the digit sum is divisible by 10, carrying the multiple of 10
       up to the next level
    """
    placeholder_16, placeholder_17, placeholder_2, placeholder_18, placeholder_19 = placeholder_13
    placeholder_20, placeholder_21, placeholder_22 = placeholder_14
    if placeholder_15 == placeholder_16:
        if placeholder_21 == 0:
            return placeholder_20
        else:
            return {}
    placeholder_23 = placeholder_19[placeholder_15]
    placeholder_24 = placeholder_21
    placeholder_25 = []
    for placeholder_26, placeholder_27 in placeholder_17[placeholder_15]:
        if placeholder_26 in placeholder_20:
            placeholder_24 += placeholder_27 * placeholder_20[placeholder_26]
        else:
            placeholder_25.append((placeholder_26, placeholder_27))
    for placeholder_28 in placeholder_0(placeholder_22, placeholder_2[placeholder_15], placeholder_18[placeholder_15]):
        placeholder_29 = dict(zip(placeholder_23, placeholder_28))
        placeholder_30 = placeholder_24 + sum([placeholder_29[placeholder_26] * placeholder_27 for placeholder_26, placeholder_27 in placeholder_25])
        placeholder_31, placeholder_32 = divmod(placeholder_30, 10)
        if placeholder_32 == 0:
            placeholder_29.update(placeholder_20)
            placeholder_33 = placeholder_12(placeholder_13, (placeholder_29, placeholder_31, placeholder_22 - set(placeholder_28)), placeholder_15 + 1)
            if placeholder_33 and len(placeholder_33) > 0:
                return placeholder_33
    return None

def placeholder_34(placeholder_35):
    """A function to solve the alphametics problem
    """
    placeholder_36 = [list(map(lambda placeholder_37: list(reversed(placeholder_37.strip())), placeholder_38.split('+'))) for placeholder_38 in placeholder_35.strip().upper().split('==')]
    placeholder_16 = max([len(placeholder_40) for placeholder_38 in placeholder_36 for placeholder_40 in placeholder_38])
    placeholder_41 = {placeholder_40[-1] for placeholder_38 in placeholder_36 for placeholder_40 in placeholder_38}
    placeholder_2 = []
    placeholder_18 = []
    placeholder_19 = []
    placeholder_17 = []
    for _ in range(placeholder_16):
        placeholder_17.append({})
        placeholder_2.append(set())
        placeholder_18.append(set())
    for placeholder_37, placeholder_38 in enumerate(placeholder_36):
        placeholder_43 = 1 - (placeholder_37 << 1)
        for placeholder_40 in placeholder_38:
            for placeholder_44, placeholder_45 in enumerate(placeholder_40):
                if placeholder_45 not in placeholder_17[placeholder_44]:
                    placeholder_17[placeholder_44][placeholder_45] = 0
                placeholder_17[placeholder_44][placeholder_45] += placeholder_43
    placeholder_46 = set()
    for placeholder_44, placeholder_47 in enumerate(placeholder_17):
        for placeholder_26, placeholder_48 in tuple(placeholder_47.items()):
            if placeholder_48 == 0:
                del placeholder_47[placeholder_26]
            elif placeholder_26 not in placeholder_46:
                if placeholder_26 in placeholder_41:
                    placeholder_2[placeholder_44].add(placeholder_26)
                else:
                    placeholder_18[placeholder_44].add(placeholder_26)
                placeholder_46.add(placeholder_26)
        placeholder_19.append(tuple(placeholder_2[placeholder_44]) + tuple(placeholder_18[placeholder_44]))
        placeholder_17[placeholder_44] = tuple(placeholder_47.items())
    return placeholder_12([placeholder_16, placeholder_17, placeholder_2, placeholder_18, placeholder_19])
