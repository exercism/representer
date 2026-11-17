from collections import defaultdict
placeholder_0 = dict(win=0, draw=1, loss=2)

def placeholder_4(placeholder_5):
    if placeholder_5 == 0:
        return 2
    elif placeholder_5 == 2:
        return 0
    return placeholder_5

def placeholder_6(placeholder_7):
    placeholder_8 = placeholder_7.split(';')
    if len(placeholder_8) == 3 and placeholder_8[2] in placeholder_0:
        placeholder_5 = placeholder_0[placeholder_8[2]]
        return ((placeholder_8[0], placeholder_5), (placeholder_8[1], placeholder_4(placeholder_5)))
    return []

def placeholder_9(placeholder_10):
    return placeholder_10[0] * 3 + placeholder_10[1]

def placeholder_11(placeholder_12):
    placeholder_13 = ['Team                           | MP |  W |  D |  L |  P']
    for placeholder_14, placeholder_15 in sorted(placeholder_12.items(), key=lambda placeholder_17: (-placeholder_9(placeholder_17[1]), placeholder_17[0])):
        placeholder_18 = '{0:30} | {1:2} | {3:2} | {4:2} | {5:2} | {2:2}'
        placeholder_13.append(placeholder_18.format(placeholder_14, sum(placeholder_15), placeholder_9(placeholder_15), *placeholder_15))
    return placeholder_13

def placeholder_19(placeholder_20):
    placeholder_13 = defaultdict(lambda: [0, 0, 0])
    for placeholder_21 in placeholder_20:
        for placeholder_14, placeholder_5 in placeholder_6(placeholder_21):
            placeholder_13[placeholder_14][placeholder_5] += 1
    return placeholder_11(placeholder_13)
