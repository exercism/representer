def placeholder_0(placeholder_1, placeholder_2):
    if len(placeholder_1) != len(placeholder_2):
        raise ValueError('Strands must be of equal length.')
    return sum((placeholder_3 != placeholder_4 for placeholder_3, placeholder_4 in zip(placeholder_1, placeholder_2)))
