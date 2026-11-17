placeholder_0 = ['twelve Drummers Drumming', 'eleven Pipers Piping', 'ten Lords-a-Leaping', 'nine Ladies Dancing', 'eight Maids-a-Milking', 'seven Swans-a-Swimming', 'six Geese-a-Laying', 'five Gold Rings', 'four Calling Birds', 'three French Hens', 'two Turtle Doves', 'a Partridge in a Pear Tree']
placeholder_1 = [None, 'first', 'second', 'third', 'fourth', 'fifth', 'sixth', 'seventh', 'eighth', 'ninth', 'tenth', 'eleventh', 'twelfth']

def placeholder_2(placeholder_3):
    placeholder_4 = placeholder_0[-placeholder_3:]
    if len(placeholder_4) > 1:
        placeholder_4[:-1] = [', '.join(placeholder_4[:-1])]
    placeholder_4 = ', and '.join(placeholder_4)
    return f'On the {placeholder_1[placeholder_3]} day of Christmas my true love gave to me: {placeholder_4}.'

def placeholder_5(placeholder_6, placeholder_7):
    return [placeholder_2(placeholder_8) for placeholder_8 in range(placeholder_6, placeholder_7 + 1)]
