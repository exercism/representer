def placeholder_0(placeholder_1):
    placeholder_1 = placeholder_4(placeholder_1)
    return sum((int(placeholder_3) * 8 ** placeholder_2 for placeholder_2, placeholder_3 in enumerate(reversed(placeholder_1))))

def placeholder_4(placeholder_1):
    for placeholder_3 in placeholder_1:
        if not '0' <= placeholder_3 < '8':
            raise ValueError('Invalid octal digit: ' + placeholder_3)
    return placeholder_1
