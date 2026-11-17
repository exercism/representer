def placeholder_0(placeholder_1=22):
    """Create a new seating chart.

    :param size: int - number if seats in the seating chart.
    :return: dict - with number of seats specified, and placeholder values.
    """
    return {placeholder_2: None for placeholder_2 in range(1, placeholder_1 + 1)}

def placeholder_3(placeholder_4=None):
    """Assign guests to seats.

    :param guest_list: list - list of guest names for reservations.
    :return: dict - Default sized dictionary with guests assigned seats,
             and placeholders for empty seats.
    """
    placeholder_5 = placeholder_0()
    if placeholder_4:
        for placeholder_6 in range(1, len(placeholder_4)):
            placeholder_5[placeholder_6] = placeholder_4[placeholder_6]
    return placeholder_5

def placeholder_7(placeholder_5):
    """Find and return seat numbers that are unassigned.

    :param seats: dict - seating chart.
    :return: list - list of seat numbers available for reserving..
    """
    placeholder_8 = []
    for placeholder_9, placeholder_10 in placeholder_5.items():
        if placeholder_10 is None:
            placeholder_8.append(placeholder_9)
    return placeholder_8

def placeholder_11(placeholder_5):
    """Find the number of seats that are currently empty.

    :param seats: dict - dictionary of reserved seats.
    :return: int - number of seats empty.
    """
    placeholder_12 = 0
    for placeholder_10 in placeholder_5.values():
        if placeholder_10 is None:
            placeholder_12 += 1
    return placeholder_12

def placeholder_13(placeholder_5, placeholder_4):
    """Asses if guest can be accommodated.  Update seating if they can be.

    :param seats: dict - seating chart dictionary.
    :param guests: list - walk-in guests
    :return: dict - updated seating chart with available spaces filled.
    """
    placeholder_14 = placeholder_11(placeholder_5)
    placeholder_15 = placeholder_7(placeholder_5)
    if len(placeholder_4) <= placeholder_14:
        for placeholder_16, _ in enumerate(placeholder_4):
            placeholder_5[placeholder_15[placeholder_16]] = placeholder_4[placeholder_16]
    return placeholder_5

def placeholder_18(placeholder_5, placeholder_19):
    """Empty listed seats of their previous reservations.

    :param seats: dict - seating chart dictionary.
    :param seat_numbers: list - list of seat numbers to free up or empty.
    :return: updated seating chart dictionary.
    """
    for placeholder_20 in placeholder_19:
        placeholder_5[placeholder_20] = None
    return placeholder_5
