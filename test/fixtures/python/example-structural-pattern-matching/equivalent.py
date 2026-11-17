from math import hypot, ceil
placeholder_0 = 'yacht'
placeholder_1, placeholder_2, placeholder_3, placeholder_4, placeholder_5, placeholder_6 = (1, 2, 3, 4, 5, 6)
placeholder_7 = 'full_house'
placeholder_8 = 'four_of_a_kind'
placeholder_9 = 'little'
placeholder_10 = 'big'
placeholder_11 = 'choice'

def placeholder_12(placeholder_13, placeholder_14):
    placeholder_13, placeholder_15 = (sorted(placeholder_13), sorted(set(placeholder_13)))
    match (placeholder_14, placeholder_15):
        case ['full_house', _] | ['choice', _]:
            placeholder_16 = any((placeholder_13.count(placeholder_17) == 3 for placeholder_17 in placeholder_15))
            return sum(placeholder_13) if placeholder_16 or placeholder_14 == 'choice' else 0
        case ['big', [2, 3, 4, 5, 6]] | ['little', [1, 2, 3, 4, 5]]:
            return 30
        case ['four_of_a_kind', _]:
            placeholder_18 = placeholder_13[0] == placeholder_13[3] or placeholder_13[1] == placeholder_13[4]
            return 4 * placeholder_13[1] if placeholder_18 else 0
        case ['yacht', _] if len(placeholder_15) == 1:
            return 50
        case _:
            return sum((placeholder_17 for placeholder_17 in placeholder_13 if placeholder_17 == placeholder_14))

def placeholder_19(placeholder_20, placeholder_21):
    match ceil(hypot(placeholder_20, placeholder_21)):
        case 0 | 1:
            return 10
        case 2 | 3 | 4 | 5:
            return 5
        case 6 | 7 | 8 | 9 | 10:
            return 1
        case _:
            return 0
