def placeholder_0(placeholder_1):
    try:
        iter(placeholder_1)
    except TypeError:
        return False
    else:
        return True

def placeholder_2(placeholder_3):
    """Flatten a list of lists."""
    placeholder_4 = []
    for placeholder_5 in placeholder_3:
        if placeholder_0(placeholder_5) and (not isinstance(placeholder_5, (str, bytes))):
            placeholder_4 += placeholder_2(placeholder_5)
        elif placeholder_5 is not None:
            placeholder_4.append(placeholder_5)
    return placeholder_4
