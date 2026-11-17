placeholder_0 = 0
placeholder_1 = 1
placeholder_2 = 2
placeholder_3 = 3

def placeholder_4(placeholder_5, placeholder_6):
    if placeholder_5 == placeholder_6:
        return placeholder_2
    if contains(placeholder_5, placeholder_6):
        return placeholder_1
    if contains(placeholder_6, placeholder_5):
        return placeholder_0
    return placeholder_3

def contains(placeholder_5, placeholder_6):
    if not placeholder_6:
        return True
    if len(placeholder_6) > len(placeholder_5):
        return False
    for placeholder_8 in range(len(placeholder_5) - len(placeholder_6) + 1):
        if placeholder_5[placeholder_8] != placeholder_6[0]:
            continue
        for placeholder_9, _ in enumerate(placeholder_6):
            if placeholder_5[placeholder_8 + placeholder_9] != placeholder_6[placeholder_9]:
                break
        else:
            return True
    return False
