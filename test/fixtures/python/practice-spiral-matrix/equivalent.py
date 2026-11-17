def placeholder_0(placeholder_1):
    placeholder_2 = [[0] * placeholder_1 for placeholder_3 in range(placeholder_1)]
    placeholder_4 = 0
    placeholder_5 = -1
    placeholder_6 = 1
    placeholder_7 = [0, 1, 0, -1]
    placeholder_8 = [1, 0, -1, 0]
    for placeholder_9 in range(2 * placeholder_1 - 1):
        for _ in range((2 * placeholder_1 - placeholder_9) // 2):
            placeholder_4 += placeholder_7[placeholder_9 % 4]
            placeholder_5 += placeholder_8[placeholder_9 % 4]
            placeholder_2[placeholder_4][placeholder_5] = placeholder_6
            placeholder_6 += 1
    return placeholder_2
