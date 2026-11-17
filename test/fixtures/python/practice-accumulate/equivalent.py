def accumulate(placeholder_1, placeholder_2):
    placeholder_3 = []
    for placeholder_4 in placeholder_1:
        placeholder_3.append(placeholder_2(placeholder_4))
    return placeholder_3
