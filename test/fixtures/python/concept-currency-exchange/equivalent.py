def placeholder_0(placeholder_1, placeholder_2):
    """

    :param budget: float - amount of money you are planning to exchange.
    :param exchange_rate: float - unit value of the foreign currency.
    :return: float - exchanged value of the foreign currency you can receive.
    """
    return placeholder_1 / placeholder_2

def placeholder_3(placeholder_1, placeholder_4):
    """

    :param budget: float - amount of money you own.
    :param exchanging_value: float - amount of your money you want to exchange now.
    :return: float - amount left of your starting currency after exchanging.
    """
    return placeholder_1 - placeholder_4

def placeholder_5(placeholder_6, placeholder_7):
    """

    :param denomination: int - the value of a bill.
    :param number_of_bills: int - total number of bills.
    :return: int - calculated value of the bills.
    """
    return placeholder_6 * placeholder_7

def placeholder_8(placeholder_9, placeholder_6):
    """

    :param amount: float - the total starting value.
    :param denomination: int - the value of a single bill.
    :return: int - number of bills that can be obtained from the amount.
    """
    return int(placeholder_9) // placeholder_6

def placeholder_10(placeholder_9, placeholder_6):
    """

    :param amount: float - the total starting value.
    :param denomination: int - the value of a single bill.
    :return: float - the amount that is "leftover", given the current denomination.
    """
    return placeholder_9 % placeholder_6

def placeholder_11(placeholder_1, placeholder_2, placeholder_12, placeholder_6):
    """

    :param budget: float - the amount of your money you are planning to exchange.
    :param exchange_rate: float - the unit value of the foreign currency.
    :param spread: int - percentage that is taken as an exchange fee.
    :param denomination: int - the value of a single bill.
    :return: int - maximum value you can get.
    """
    placeholder_13 = placeholder_2 / 100 * placeholder_12
    placeholder_14 = placeholder_0(placeholder_1, placeholder_2 + placeholder_13)
    placeholder_7 = placeholder_8(placeholder_14, placeholder_6)
    placeholder_15 = placeholder_5(placeholder_6, placeholder_7)
    return placeholder_15
