from math import sqrt

def placeholder_0(placeholder_1, placeholder_2):
    placeholder_3 = sqrt(placeholder_1 * placeholder_1 + placeholder_2 * placeholder_2)
    if placeholder_3 <= 1.0:
        return 10
    elif placeholder_3 <= 5.0:
        return 5
    elif placeholder_3 <= 10.0:
        return 1
    else:
        return 0
