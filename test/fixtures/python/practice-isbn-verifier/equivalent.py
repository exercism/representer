def placeholder_0(placeholder_1):
    placeholder_2 = list(placeholder_1.replace('-', ''))
    if placeholder_2 and placeholder_2[-1] == 'X':
        placeholder_2[-1] = '10'
    if not len(placeholder_2) == 10 or not all((placeholder_3.isdigit() for placeholder_3 in placeholder_2)):
        return False
    placeholder_4 = list(range(10, 0, -1))
    return sum((int(placeholder_3) * placeholder_5 for placeholder_3, placeholder_5 in zip(placeholder_2, placeholder_4))) % 11 == 0
