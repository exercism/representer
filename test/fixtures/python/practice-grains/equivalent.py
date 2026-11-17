def placeholder_0(placeholder_1):
    if placeholder_1 == 0:
        raise ValueError('square must be between 1 and 64')
    elif placeholder_1 < 0:
        raise ValueError('square must be between 1 and 64')
    elif placeholder_1 > 64:
        raise ValueError('square must be between 1 and 64')
    return 2 ** (placeholder_1 - 1)

def placeholder_2():
    return 2 ** 64 - 1
