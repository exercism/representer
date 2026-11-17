"""Functions for tracking poker hands and assorted card tasks.

Python list documentation: https://docs.python.org/3/tutorial/datastructures.html
"""

def placeholder_0(placeholder_1):
    """Create a list containing the current and next two round numbers.

    :param number: int - current round number.
    :return: list - current round and the two that follow.
    """
    return [placeholder_1, placeholder_1 + 1, placeholder_1 + 2]

def placeholder_2(placeholder_3, placeholder_4):
    """Concatenate two lists of round numbers.

    :param rounds_1: list - first rounds played.
    :param rounds_2: list - second set of rounds played.
    :return: list - all rounds played.
    """
    return placeholder_3 + placeholder_4

def placeholder_5(placeholder_6, placeholder_1):
    """Check if the list of rounds contains the specified number.

    :param rounds: list - rounds played.
    :param number: int - round number.
    :return: bool - was the round played?
    """
    return placeholder_1 in placeholder_6

def placeholder_7(placeholder_8):
    """Calculate and returns the average card value from the list.

    :param hand: list - cards in hand.
    :return: float - average value of the cards in the hand.
    """
    return sum(placeholder_8) / len(placeholder_8)

def placeholder_9(placeholder_8):
    """Return if an average is using (first + last index values ) OR ('middle' card) == calculated average.

    :param hand: list - cards in hand.
    :return: bool - does one of the approximate averages equal the `true average`?
    """
    placeholder_10 = placeholder_7(placeholder_8)
    if placeholder_7([placeholder_8[0], placeholder_8[-1]]) == placeholder_10:
        placeholder_11 = True
    elif placeholder_8[len(placeholder_8) // 2] == placeholder_10:
        placeholder_11 = True
    else:
        placeholder_11 = False
    return placeholder_11

def placeholder_12(placeholder_8):
    """Return if the (average of even indexed card values) == (average of odd indexed card values).

    :param hand: list - cards in hand.
    :return: bool - are even and odd averages equal?
    """
    return placeholder_7(placeholder_8[::2]) == placeholder_7(placeholder_8[1::2])

def placeholder_13(placeholder_8):
    """Multiply a Jack card value in the last index position by 2.

    :param hand: list - cards in hand.
    :return: list - hand with Jacks (if present) value doubled.
    """
    if placeholder_8[-1] == 11:
        placeholder_8[-1] *= 2
    return placeholder_8
