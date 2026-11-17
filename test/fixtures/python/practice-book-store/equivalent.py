from collections import Counter
placeholder_0 = 800.0
placeholder_1 = {1: 1 * placeholder_0 * 1.0, 2: 2 * placeholder_0 * 0.95, 3: 3 * placeholder_0 * 0.9, 4: 4 * placeholder_0 * 0.8, 5: 5 * placeholder_0 * 0.75}

def placeholder_2(placeholder_3):
    placeholder_4 = Counter(placeholder_3)
    placeholder_5 = len(placeholder_3) * placeholder_0
    for placeholder_6 in range(len(placeholder_4), 1, -1):
        placeholder_7 = placeholder_4 - Counter((placeholder_8 for placeholder_8, _ in placeholder_4.most_common(placeholder_6)))
        placeholder_10 = sorted(placeholder_7.elements())
        placeholder_5 = min(placeholder_5, placeholder_1[placeholder_6] + placeholder_2(placeholder_10))
    return placeholder_5

def placeholder_11(placeholder_3):
    if not placeholder_3:
        return 0
    return placeholder_2(sorted(placeholder_3))
