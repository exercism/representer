def placeholder_0(placeholder_1):
    if placeholder_1 <= 0:
        raise ValueError('Only positive integers are allowed')
    placeholder_2 = 0
    while placeholder_1 > 1:
        if placeholder_3(placeholder_1):
            placeholder_1 = placeholder_1 * 3 + 1
        else:
            placeholder_1 = placeholder_1 / 2
        placeholder_2 += 1
    return placeholder_2

def placeholder_3(placeholder_1):
    return placeholder_1 % 2 == 1
