class placeholder_0(Exception):
    """Exception raised when Stack is not full.
       message: explanation of the error.
    """

    def __init__(self, placeholder_2):
        self.placeholder_2 = placeholder_2

def is_integer(placeholder_4):
    try:
        int(placeholder_4)
        return True
    except ValueError:
        return False

def placeholder_5(placeholder_6):
    if not placeholder_6:
        return []
    placeholder_7 = {}
    while placeholder_6[0][:1] == ':':
        placeholder_8 = placeholder_6.pop(0).split()
        placeholder_8.pop()
        placeholder_8.pop(0)
        placeholder_9 = placeholder_8.pop(0).lower()
        if is_integer(placeholder_9):
            raise ValueError('illegal operation')
        placeholder_7[placeholder_9] = [placeholder_11 for placeholder_10 in placeholder_8 for placeholder_11 in placeholder_7.get(placeholder_10, [placeholder_10])]
    placeholder_12 = []
    placeholder_6 = placeholder_6[-1].split()
    while any(placeholder_6):
        placeholder_13 = placeholder_6.pop(0).lower()
        try:
            if is_integer(placeholder_13):
                placeholder_12.append(int(placeholder_13))
            elif placeholder_13 in placeholder_7:
                placeholder_6 = placeholder_7[placeholder_13] + placeholder_6
            elif placeholder_13 == '+':
                placeholder_12.append(placeholder_12.pop() + placeholder_12.pop())
            elif placeholder_13 == '-':
                placeholder_12.append(-placeholder_12.pop() + placeholder_12.pop())
            elif placeholder_13 == '*':
                placeholder_12.append(placeholder_12.pop() * placeholder_12.pop())
            elif placeholder_13 == '/':
                placeholder_14 = placeholder_12.pop()
                if placeholder_14 == 0:
                    raise ZeroDivisionError('divide by zero')
                placeholder_12.append(int(placeholder_12.pop() / placeholder_14))
            elif placeholder_13 == 'dup':
                placeholder_12.append(placeholder_12[-1])
            elif placeholder_13 == 'drop':
                placeholder_12.pop()
            elif placeholder_13 == 'swap':
                placeholder_12.append(placeholder_12[-2])
                del placeholder_12[-3]
            elif placeholder_13 == 'over':
                placeholder_12.append(placeholder_12[-2])
            else:
                raise ValueError('undefined operation')
        except IndexError as placeholder_15:
            raise placeholder_0('Insufficient number of items in stack') from placeholder_15
    return placeholder_12
