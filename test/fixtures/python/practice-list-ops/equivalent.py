def append(placeholder_1, placeholder_2):
    return concat([placeholder_1, placeholder_2])

def concat(placeholder_4):
    return [placeholder_5 for list in placeholder_4 for placeholder_5 in list]

def filter(placeholder_6, list):
    return [placeholder_7 for placeholder_7 in list if placeholder_6(placeholder_7)]

def placeholder_8(list):
    return sum((1 for _ in list))

def map(placeholder_6, list):
    return [placeholder_6(placeholder_5) for placeholder_5 in list]

def placeholder_10(placeholder_6, list, placeholder_11):
    if len(list) == 0:
        return placeholder_11
    else:
        return placeholder_10(placeholder_6, list[1:], placeholder_6(placeholder_11, list[0]))

def placeholder_12(placeholder_6, list, placeholder_11):
    if len(list) == 0:
        return placeholder_11
    else:
        return placeholder_6(placeholder_12(placeholder_6, list[1:], placeholder_11), list[0])

def reverse(list):
    return list[::-1]
