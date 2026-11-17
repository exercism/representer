"""Functions for tracking poker hands and assorted card tasks.

Python list documentation: https://docs.python.org/3/tutorial/datastructures.html
"""

def placeholder_0(placeholder_1):
    """

     :param number: int - current round number.
     :return: list - current round and the two that follow.
    """
    print([int(placeholder_1), int(placeholder_1) + 1, int(placeholder_1) + 2])
    return [int(placeholder_1), int(placeholder_1) + 1, int(placeholder_1) + 2]

def placeholder_2(placeholder_3, placeholder_4):
    """

    :param rounds_1: list - first rounds played.
    :param rounds_2: list - second set of rounds played.
    :return: list - all rounds played.
    """
    print(placeholder_3 + placeholder_4)
    return placeholder_3 + placeholder_4

def placeholder_5(placeholder_6, placeholder_1):
    """

    :param rounds: list - rounds played.
    :param number: int - round number.
    :return:  bool - was the round played?
    """
    if placeholder_1 in placeholder_6:
        print(placeholder_1)
        return True
    else:
        print(placeholder_6)
        return False

def placeholder_7(placeholder_8):
    """

    :param hand: list - cards in hand.
    :return:  float - average value of the cards in the hand.
    """
    return round(sum(placeholder_8) / len(placeholder_8), 1)

def placeholder_9(placeholder_8):
    """

    :param hand: list - cards in hand.
    :return: bool - if approximate average equals to the `true average`.
    """
    placeholder_10 = sum(placeholder_8) / len(placeholder_8)
    placeholder_11 = placeholder_10 == (placeholder_8[0] + placeholder_8[-1]) / 2
    import statistics
    print((placeholder_8[0] + placeholder_8[-1]) / 2)
    placeholder_12 = placeholder_10 == statistics.median(placeholder_8)
    print(placeholder_8[0] + placeholder_8[-1])
    if placeholder_12 == True or placeholder_11 == True:
        print(placeholder_12)
        return True
    else:
        return False

def placeholder_13(placeholder_8):
    """

    :param hand: list - cards in hand.
    :return: bool - are even and odd averages equal?
    """
    placeholder_14 = list(range(1, len(placeholder_8), 2))
    placeholder_15 = list(range(0, len(placeholder_8), 2))
    print([placeholder_14, placeholder_15])
    placeholder_16 = len(placeholder_8[0:len(placeholder_8):2])
    placeholder_17 = sum(placeholder_8[0:len(placeholder_8):2]) / placeholder_16
    placeholder_18 = len(placeholder_8[1:len(placeholder_8):2])
    placeholder_19 = sum(placeholder_8[1:len(placeholder_8):2]) / placeholder_18
    print(placeholder_17, placeholder_16)
    return placeholder_17 == placeholder_19

def placeholder_20(placeholder_8):
    """

    :param hand: list - cards in hand.
    :return: list - hand with Jacks (if present) value doubled.
    """
    if placeholder_8[-1] == 11:
        print(placeholder_8)
        return [placeholder_8[0], placeholder_8[1], placeholder_8[-1] * 2]
    else:
        print('Nothing found!', placeholder_8)
        return placeholder_8
