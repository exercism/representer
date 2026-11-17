placeholder_0 = {10: 'ten', 9: 'nine', 8: 'eight', 7: 'seven', 6: 'six', 5: 'five', 4: 'four', 3: 'three', 2: 'two', 1: 'one', 0: 'no'}

def placeholder_1(placeholder_2, placeholder_3=1):
    placeholder_4 = []
    for placeholder_5 in range(placeholder_2, placeholder_2 - placeholder_3, -1):
        placeholder_4.extend(placeholder_6(placeholder_5))
        if placeholder_5 > placeholder_2 - placeholder_3 + 1:
            placeholder_4.append('')
    return placeholder_4

def placeholder_6(placeholder_7):
    return [*placeholder_8(placeholder_7), 'And if one green bottle should accidentally fall,', placeholder_9(placeholder_7)]

def placeholder_8(placeholder_7):
    if placeholder_7 == 1:
        return [f'One green bottle hanging on the wall,', f'One green bottle hanging on the wall,']
    else:
        return [f'{placeholder_0[placeholder_7].capitalize()} green bottles hanging on the wall,', f'{placeholder_0[placeholder_7].capitalize()} green bottles hanging on the wall,']

def placeholder_9(placeholder_7):
    if placeholder_7 - 1 == 1:
        return f"There'll be one green bottle hanging on the wall."
    else:
        return f"There'll be {placeholder_0[placeholder_7 - 1]} green bottles hanging on the wall."
