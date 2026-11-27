def placeholder_0(placeholder_1, placeholder_2):
    if len(placeholder_1) != len(placeholder_2):
        raise ValueError('traversals must have the same length')
    if set(placeholder_1) != set(placeholder_2):
        raise ValueError('traversals must have the same elements')
    if len(set(placeholder_1)) != len(placeholder_1) != len(set(placeholder_2)):
        raise ValueError('traversals must contain unique items')
    if not placeholder_1:
        return {}
    placeholder_3 = placeholder_1.pop(0)
    placeholder_4 = placeholder_2.placeholder_4(placeholder_3)
    placeholder_5, placeholder_6 = (placeholder_2[:placeholder_4], placeholder_2[placeholder_4 + 1:])
    placeholder_7 = [placeholder_8 for placeholder_8 in placeholder_1 if placeholder_8 in placeholder_5]
    placeholder_9 = [placeholder_8 for placeholder_8 in placeholder_1 if placeholder_8 in placeholder_6]
    placeholder_10 = placeholder_0(placeholder_7, placeholder_5)
    placeholder_11 = placeholder_0(placeholder_9, placeholder_6)
    return {'v': placeholder_3, 'l': placeholder_10, 'r': placeholder_11}
