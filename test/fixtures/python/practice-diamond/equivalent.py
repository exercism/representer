def placeholder_0(placeholder_1):
    placeholder_2 = ord(placeholder_1) - 64
    placeholder_3 = placeholder_2 * 2 - 1
    placeholder_4 = placeholder_5(placeholder_2, placeholder_3)
    return placeholder_4 + placeholder_4[-2::-1]

def placeholder_5(placeholder_2, placeholder_3):
    placeholder_6 = []
    for placeholder_7 in range(placeholder_2):
        placeholder_8 = [' '] * placeholder_3
        placeholder_8[placeholder_2 - 1 - placeholder_7] = chr(placeholder_7 + 65)
        placeholder_8[placeholder_2 - 1 + placeholder_7] = chr(placeholder_7 + 65)
        placeholder_6.append(''.join(placeholder_8))
    return placeholder_6
