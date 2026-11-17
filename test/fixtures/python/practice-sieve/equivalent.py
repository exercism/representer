def placeholder_0(placeholder_1):
    placeholder_2 = [True] * (placeholder_1 + 1)
    placeholder_2[0] = placeholder_2[1] = False
    for placeholder_3 in range(2, int(placeholder_1 ** 0.5) + 1):
        if placeholder_2[placeholder_3]:
            for placeholder_4 in range(placeholder_3 * placeholder_3, placeholder_1 + 1, placeholder_3):
                placeholder_2[placeholder_4] = False
    return [placeholder_4 for placeholder_4, placeholder_3 in enumerate(placeholder_2) if placeholder_3]
