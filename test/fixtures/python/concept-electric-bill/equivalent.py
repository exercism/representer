"""Functions to help the company calculate their power usage."""

def placeholder_0(placeholder_1):
    """Return the number of hours.

    :param: hours: int - number of hours.
    :return: int - number of "extra" hours.
    """
    return (placeholder_1 + 3) % 24

def placeholder_2(placeholder_3):
    """Return the kW amount of a given watt amount.

    :param: watts: int - watt amount.
    :return: float - kW amount.
    """
    return round(placeholder_3 / 1000, 1)

def placeholder_4(placeholder_3):
    """Return the kWh amount of a given watt amount and hours.

    :param: watts: int - watt amount.
    :return: int - kilowatt hour amount.
    """
    return placeholder_2(placeholder_3) // 3600

def placeholder_5(placeholder_6):
    """Return the efficiency calculated from the power factor.

    :param: power_factor: float.
    :return: float - efficiency.
    """
    return placeholder_6 / 100

def placeholder_7(placeholder_3, placeholder_6, placeholder_8):
    """Calculate the cost of a given kWh value, efficiency and price.

    :param: watts: int - watt value.
    :param: power_factor: float - efficiency.
    :param: price: float - price of kWh.
    :return: float - cost of kWh.
    """
    return placeholder_8 * (placeholder_4(placeholder_3) / placeholder_5(placeholder_6))
