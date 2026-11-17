placeholder_0 = ['black', 'brown', 'red', 'orange', 'yellow', 'green', 'blue', 'violet', 'grey', 'white']

def placeholder_1(placeholder_2):
    placeholder_3 = 10 * placeholder_0.index(placeholder_2[0]) + placeholder_0.index(placeholder_2[1])
    placeholder_3 *= 10 ** placeholder_0.index(placeholder_2[2])
    placeholder_1 = str(placeholder_3)
    if len(placeholder_1) < 4:
        placeholder_4 = 'ohms'
    elif len(placeholder_1) < 7:
        placeholder_1 = str(placeholder_3 // 1000)
        placeholder_4 = 'kiloohms'
    elif len(placeholder_1) <= 8:
        placeholder_1 = str(placeholder_3 // 1000000)
        placeholder_4 = 'megaohms'
    elif len(placeholder_1) >= 9:
        placeholder_1 = str(placeholder_3 // 1000000000)
        placeholder_4 = 'gigaohms'
    return f'{(placeholder_3 if placeholder_3 < 1000 else placeholder_1)} {placeholder_4}'
