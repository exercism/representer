def placeholder_0(placeholder_1, placeholder_2):
    if not placeholder_1:
        raise ValueError('series cannot be empty')
    elif placeholder_2 == 0:
        raise ValueError('slice length cannot be zero')
    elif placeholder_2 < 0:
        raise ValueError('slice length cannot be negative')
    elif len(placeholder_1) < placeholder_2:
        raise ValueError('slice length cannot be greater than series length')
    return [placeholder_1[placeholder_3:placeholder_3 + placeholder_2] for placeholder_3 in range(len(placeholder_1) - placeholder_2 + 1)]
