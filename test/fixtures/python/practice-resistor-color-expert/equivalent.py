placeholder_0 = ['black', 'brown', 'red', 'orange', 'yellow', 'green', 'blue', 'violet', 'grey', 'white']
placeholder_1 = {'brown': 1, 'red': 2, 'green': 0.5, 'blue': 0.25, 'violet': 0.1, 'grey': 0.05, 'gold': 5, 'silver': 10}

def placeholder_2(placeholder_3):
    if len(placeholder_3) == 1:
        return f'0 ohms'
    elif len(placeholder_3) == 4:
        placeholder_4 = 10 * placeholder_0.index(placeholder_3[0]) + placeholder_0.index(placeholder_3[1])
        placeholder_4 *= 10 ** placeholder_0.index(placeholder_3[2])
        placeholder_4, placeholder_5 = placeholder_6(placeholder_4)
        placeholder_4 = int(placeholder_4) if placeholder_4.is_integer() else placeholder_4
        return f'{placeholder_4} {placeholder_5} ±{placeholder_1[placeholder_3[3]]}%'
    else:
        placeholder_4 = 100 * placeholder_0.index(placeholder_3[0]) + 10 * placeholder_0.index(placeholder_3[1]) + placeholder_0.index(placeholder_3[2])
        placeholder_4 *= 10 ** placeholder_0.index(placeholder_3[3])
        placeholder_4, placeholder_5 = placeholder_6(placeholder_4)
        placeholder_4 = int(placeholder_4) if placeholder_4.is_integer() else placeholder_4
        return f'{placeholder_4} {placeholder_5} ±{placeholder_1[placeholder_3[4]]}%'

def placeholder_6(placeholder_7):
    if placeholder_7 < 1000:
        return (placeholder_7 / 1, 'ohms')
    elif placeholder_7 < 1000000:
        return (placeholder_7 / 1000, 'kiloohms')
    else:
        return (placeholder_7 / 1000000, 'megaohms')
