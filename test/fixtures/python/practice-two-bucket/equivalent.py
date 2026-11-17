"""
    This solution implements a breadth-first search of the graph
    of possible valid states for the two buckets until it reaches a state
    in which one of the two buckets contains the goal amount
"""

def placeholder_0(placeholder_1, placeholder_2, placeholder_3, placeholder_4):
    placeholder_5 = [placeholder_1, placeholder_2]
    placeholder_6 = 0 if placeholder_4 == 'one' else 1

    def placeholder_7(placeholder_8, placeholder_9):
        return [0, placeholder_8[1]] if placeholder_9 == 0 else [placeholder_8[0], 0]

    def placeholder_10(placeholder_8, placeholder_9):
        return [placeholder_5[0], placeholder_8[1]] if placeholder_9 == 0 else [placeholder_8[0], placeholder_5[1]]

    def placeholder_11(placeholder_8, placeholder_9):
        placeholder_12 = min(placeholder_8[1 - placeholder_9], placeholder_5[placeholder_9] - placeholder_8[placeholder_9])
        placeholder_13 = placeholder_8[placeholder_9] + placeholder_12
        placeholder_14 = placeholder_8[1 - placeholder_9] - placeholder_12
        return [placeholder_13, placeholder_14] if placeholder_9 == 0 else [placeholder_14, placeholder_13]

    def placeholder_15(placeholder_8):
        return f'{placeholder_8[0]},{placeholder_8[1]}'
    placeholder_16 = [0, 0]
    placeholder_16[1 - placeholder_6] = placeholder_5[1 - placeholder_6]
    placeholder_17 = placeholder_15(placeholder_16)
    placeholder_8 = [0, 0]
    placeholder_8[placeholder_6] = placeholder_5[placeholder_6]
    placeholder_18 = []
    placeholder_19 = set()
    placeholder_20 = 1
    while placeholder_3 not in placeholder_8:
        placeholder_21 = placeholder_15(placeholder_8)
        if placeholder_21 != placeholder_17 and placeholder_21 not in placeholder_19:
            placeholder_19.add(placeholder_21)
            placeholder_22 = placeholder_20 + 1
            for placeholder_9 in range(2):
                if placeholder_8[placeholder_9] != 0:
                    placeholder_18.append((placeholder_7(placeholder_8, placeholder_9), placeholder_22))
                if placeholder_8[placeholder_9] != placeholder_5[placeholder_9]:
                    placeholder_18.append((placeholder_10(placeholder_8, placeholder_9), placeholder_22))
                    placeholder_18.append((placeholder_11(placeholder_8, placeholder_9), placeholder_22))
        if not any(placeholder_18):
            raise ValueError('No more moves!')
        placeholder_8, placeholder_20 = placeholder_18.pop(0)
    placeholder_6 = placeholder_8.index(placeholder_3)
    placeholder_23 = ['one', 'two'][placeholder_6]
    placeholder_24 = placeholder_8[1 - placeholder_6]
    return (placeholder_20, placeholder_23, placeholder_24)
