def placeholder_0(placeholder_1, placeholder_2=1):
    placeholder_3 = []
    for placeholder_4 in range(placeholder_1, placeholder_1 - placeholder_2, -1):
        placeholder_3.extend(placeholder_5(placeholder_4))
        if placeholder_4 > placeholder_1 - placeholder_2 + 1:
            placeholder_3.append('')
    return placeholder_3

def placeholder_5(placeholder_6):
    return [f'{placeholder_10(placeholder_6).capitalize()} of beer on the wall, {placeholder_10(placeholder_6)} of beer.', f'{placeholder_7(placeholder_6)}{placeholder_9(placeholder_6)}']

def placeholder_7(placeholder_8):
    if placeholder_8 == 0:
        return 'Go to the store and buy some more, '
    else:
        return f"Take {('one' if placeholder_8 > 1 else 'it')} down and pass it around, "

def placeholder_9(placeholder_8):
    return f'{placeholder_10(placeholder_11(placeholder_8))} of beer on the wall.'

def placeholder_10(placeholder_6):
    if placeholder_6 == 0:
        return 'no more bottles'
    if placeholder_6 == 1:
        return '1 bottle'
    else:
        return f'{placeholder_6} bottles'

def placeholder_11(placeholder_8):
    return placeholder_8 - 1 if placeholder_8 > 0 else 99
