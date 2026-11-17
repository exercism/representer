placeholder_0 = ((1000, 'M'), (900, 'CM'), (500, 'D'), (400, 'CD'), (100, 'C'), (90, 'XC'), (50, 'L'), (40, 'XL'), (10, 'X'), (9, 'IX'), (5, 'V'), (4, 'IV'), (1, 'I'))

def placeholder_1(placeholder_2):
    placeholder_3 = ''
    for placeholder_4, placeholder_5 in placeholder_0:
        while placeholder_2 >= placeholder_4:
            placeholder_3 += placeholder_5
            placeholder_2 -= placeholder_4
    return placeholder_3
