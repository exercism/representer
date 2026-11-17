def placeholder_0(placeholder_1):
    """
    Converts a number to a string according to the raindrop sounds.
    """
    placeholder_2 = ''
    if placeholder_1 % 3 == 0:
        placeholder_2 += 'Pling'
    if placeholder_1 % 5 == 0:
        placeholder_2 += 'Plang'
    if placeholder_1 % 7 == 0:
        placeholder_2 += 'Plong'
    if not placeholder_2:
        placeholder_2 = str(placeholder_1)
    return placeholder_2
