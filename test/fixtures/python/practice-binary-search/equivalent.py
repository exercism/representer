def find(placeholder_1, placeholder_2):
    placeholder_3 = 0
    placeholder_4 = len(placeholder_1) - 1
    while placeholder_3 <= placeholder_4:
        placeholder_5 = (placeholder_3 + placeholder_4) // 2
        if placeholder_1[placeholder_5] > placeholder_2:
            placeholder_4 = placeholder_5 - 1
        elif placeholder_1[placeholder_5] < placeholder_2:
            placeholder_3 = placeholder_5 + 1
        else:
            return placeholder_5
    raise ValueError('value not in array')
