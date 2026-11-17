def placeholder_0(placeholder_1):
    if set(placeholder_1) - set('01'):
        raise ValueError('Invalid binary literal: ' + placeholder_1)
    return sum((int(placeholder_3) * 2 ** placeholder_2 for placeholder_2, placeholder_3 in enumerate(reversed(placeholder_1))))
