def placeholder_0(placeholder_1, placeholder_2):
    placeholder_3 = [[0 for _ in range(len(placeholder_2) + 1)] for _ in range(placeholder_1 + 1)]
    for placeholder_6 in range(1, placeholder_1 + 1):
        for placeholder_7, placeholder_8 in enumerate(placeholder_2, 1):
            if placeholder_8['weight'] <= placeholder_6:
                placeholder_9 = placeholder_8['value'] + placeholder_3[placeholder_6 - placeholder_8['weight']][placeholder_7 - 1]
                placeholder_10 = placeholder_3[placeholder_6][placeholder_7 - 1]
                placeholder_3[placeholder_6][placeholder_7] = max(placeholder_9, placeholder_10)
            else:
                placeholder_3[placeholder_6][placeholder_7] = placeholder_3[placeholder_6][placeholder_7 - 1]
    return placeholder_3[placeholder_1][len(placeholder_2)]
