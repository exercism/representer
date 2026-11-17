def placeholder_0(placeholder_1, placeholder_2):
    if placeholder_2 < 0:
        raise ValueError("target can't be negative")
    placeholder_3 = [1000000000.0] * (placeholder_2 + 1)
    placeholder_4 = [0] * (placeholder_2 + 1)
    placeholder_3[0] = 0
    placeholder_4[0] = -1
    for placeholder_5 in range(1, placeholder_2 + 1):
        placeholder_6 = placeholder_3[placeholder_5]
        for placeholder_7 in placeholder_1:
            if placeholder_7 <= placeholder_5:
                placeholder_8 = placeholder_3[placeholder_5 - placeholder_7] + 1
                if placeholder_8 < placeholder_6:
                    placeholder_6 = placeholder_8
                    placeholder_4[placeholder_5] = placeholder_5 - placeholder_7
        placeholder_3[placeholder_5] = placeholder_6
    if placeholder_3[placeholder_2] == 1000000000.0:
        raise ValueError("can't make target with given coins")
    else:
        placeholder_9 = placeholder_2
        placeholder_10 = []
        while placeholder_4[placeholder_9] != -1:
            placeholder_10.append(placeholder_9 - placeholder_4[placeholder_9])
            placeholder_9 = placeholder_4[placeholder_9]
        return placeholder_10
