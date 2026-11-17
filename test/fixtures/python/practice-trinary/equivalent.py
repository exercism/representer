from functools import reduce

def placeholder_0(placeholder_1):
    if set(placeholder_1) - set('012'):
        return 0
    return reduce(lambda placeholder_2, placeholder_3: placeholder_2 * 3 + int(placeholder_3), placeholder_1, 0)
