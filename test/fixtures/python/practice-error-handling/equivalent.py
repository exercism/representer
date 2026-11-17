def placeholder_0():
    raise Exception('Meaningful message describing the source of the error')

def placeholder_1(placeholder_2):
    try:
        return int(placeholder_2)
    except ValueError:
        return None

def placeholder_3(placeholder_2):
    try:
        return (True, int(placeholder_2))
    except ValueError:
        return (False, None)

def placeholder_4(placeholder_5):
    with placeholder_5 as placeholder_6:
        placeholder_6.do_something()
