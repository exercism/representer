"""Functions for tracking poker hands and assorted card tasks.

Python list documentation: https://docs.python.org/3/tutorial/datastructures.html
"""
import statistics

def placeholder_0(placeholder_1):
    """

     :param number: int - current round number.
     :return: list - current round and the two that follow.
    """
    return [int(placeholder_1), int(placeholder_1) + 1, int(placeholder_1) + 2]

def placeholder_2(placeholder_3, placeholder_4):
    """

    :param rounds_1: list - first rounds played.
    :param rounds_2: list - second set of rounds played.
    :return: list - all rounds played.
    """
    return placeholder_3 + placeholder_4

def placeholder_5(placeholder_6, placeholder_1):
    """

    :param rounds: list - rounds played.
    :param number: int - round number.
    :return:  bool - was the round played?
    """
    if placeholder_1 in placeholder_6:
        return True
    else:
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
    placeholder_12 = placeholder_10 == statistics.median(placeholder_8)
    if placeholder_12 == True or placeholder_11 == True:
        return True
    else:
        return False

def placeholder_13(placeholder_8):
    """

    :param hand: list - cards in hand.
    :return: bool - are even and odd averages equal?
    """
    placeholder_14 = len(placeholder_8[0:len(placeholder_8):2])
    placeholder_15 = sum(placeholder_8[0:len(placeholder_8):2]) / placeholder_14
    placeholder_16 = len(placeholder_8[1:len(placeholder_8):2])
    placeholder_17 = sum(placeholder_8[1:len(placeholder_8):2]) / placeholder_16
    return placeholder_15 == placeholder_17

def placeholder_18(placeholder_8):
    """

    :param hand: list - cards in hand.
    :return: list - hand with Jacks (if present) value doubled.
    """
    if placeholder_8[-1] == 11:
        return [placeholder_8[0], placeholder_8[1], placeholder_8[-1] * 2]
    else:
        return placeholder_8
if __name__ == '__main__':
    print(f'list of rounds: {placeholder_0(7)}')
    print(f'list 1 and 2: {placeholder_2([27, 28, 29], [35, 36])}')
    print(f'Is round played?: {placeholder_5([27, 28, 21], 28)}')
    print(f'Average on hand: {placeholder_7([0, 1, 5])}')
    print(f'Aprox Average on hand: {placeholder_9([1, 2, 3, 5, 9])}')
    print(f'Is odd == even: {placeholder_13([1, 2, 3, 4])}')
    print(f'Hand after mayby double: {placeholder_18([1, 2, 11])}')
