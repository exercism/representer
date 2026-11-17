"""Functions which helps the locomotive engineer to keep track of the train."""

def placeholder_0(*placeholder_1):
    """Return a list of wagons.

    :param *args: arbitrary number of wagons.
    :return: list - list of wagons.
    """
    return list(placeholder_1)

def placeholder_2(placeholder_3, placeholder_4):
    """Fix the list of wagons.

    :param each_wagons_id: list - the list of wagons.
    :param missing_wagons: list - the list of missing wagons.
    :return: list - list of wagons.
    """
    placeholder_5, placeholder_6, placeholder_7, *placeholder_8 = placeholder_3
    return [placeholder_7, *placeholder_4, *placeholder_8, placeholder_5, placeholder_6]

def placeholder_9(placeholder_10, **placeholder_11):
    """Add missing stops to route dict.

    :param route: dict - the dict of routing information.
    :param **kwargs: arbitrary number of stops.
    :return: dict - updated route dictionary.
    """
    return {**placeholder_10, 'stops': list(placeholder_11.values())}

def placeholder_12(placeholder_10, placeholder_13):
    """Extend route information with more_route_information.

    :param route: dict - the route information.
    :param more_route_information: dict - extra route information.
    :return: dict - extended route information.
    """
    return {**placeholder_10, **placeholder_13}

def placeholder_14(placeholder_15):
    """Fix the list of rows of wagons.

    :param wagons_rows: list[tuple] - the list of rows of wagons.
    :return: list[tuple] - list of rows of wagons.
    """
    [*placeholder_16], [*placeholder_17], [*placeholder_18] = zip(*placeholder_15)
    return [placeholder_16, placeholder_17, placeholder_18]
