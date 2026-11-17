def placeholder_0(placeholder_1, placeholder_2=[1]):
    if placeholder_1 < 0:
        raise ValueError('number of rows is negative')
    elif placeholder_1 == 0:
        return []
    placeholder_3 = placeholder_2 + [0]
    placeholder_4 = list(map(sum, zip(placeholder_3, placeholder_3[::-1])))
    return [placeholder_2] + placeholder_0(placeholder_1 - 1, placeholder_4)
