from operator import add, mul, sub
from operator import floordiv as placeholder_0
placeholder_1 = {'plus': add, 'minus': sub, 'multiplied by': mul, 'divided by': placeholder_0}

def placeholder_2(placeholder_3):
    if not bool(placeholder_3[8:-1].strip().lower().split()):
        raise ValueError('syntax error')
    elif not placeholder_3.startswith('What is '):
        raise ValueError('unknown operation')
    else:
        placeholder_4 = placeholder_3[8:-1].strip().lower().split()
        placeholder_4.reverse()
    try:
        placeholder_5 = int(placeholder_4.pop())
    except ValueError as placeholder_6:
        raise ValueError('syntax error') from placeholder_6
    while placeholder_4:
        placeholder_7 = [placeholder_4.pop()]
        while placeholder_4:
            try:
                placeholder_8 = placeholder_4.pop()
                placeholder_9 = int(placeholder_8)
                break
            except ValueError as placeholder_6:
                if placeholder_8 == placeholder_7[-1]:
                    raise ValueError('syntax error') from placeholder_6
                else:
                    placeholder_7.append(placeholder_8)
        else:
            if placeholder_7[-1] not in placeholder_1 and (not placeholder_7[-1].isdigit()):
                raise ValueError('unknown operation')
            else:
                raise ValueError('syntax error')
        placeholder_7 = ' '.join(placeholder_7)
        try:
            placeholder_5 = placeholder_1[placeholder_7](placeholder_5, placeholder_9)
        except KeyError as placeholder_6:
            raise ValueError('syntax error') from placeholder_6
    return placeholder_5
