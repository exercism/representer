"""Functions to help play and score a game of blackjack.

How to play blackjack:    https://bicyclecards.com/how-to-play/blackjack/
"Standard" playing cards: https://en.wikipedia.org/wiki/Standard_52-card_deck
"""

def placeholder_0(placeholder_1):
    """Determine the scoring value of a card.

    :param card: str - given card.
    :return: int - value of a given card.  See below for values.

    1.  'J', 'Q', or 'K' (otherwise known as "face cards") = 10
    2.  'A' (ace card) = 1
    3.  '2' - '10' = numerical value.
    """
    if placeholder_1 in 'JQK':
        placeholder_2 = 10
    elif placeholder_1 == 'A':
        placeholder_2 = 1
    else:
        placeholder_2 = int(placeholder_1)
    return placeholder_2

def placeholder_3(placeholder_4, placeholder_5):
    """Determine which card has a higher value in the hand.

    :param card_one, card_two: str - cards dealt in hand.  See below for values.
    :return: str or tuple - resulting Tuple contains both cards if they are of equal value.

    1.  'J', 'Q', or 'K' (otherwise known as "face cards") = 10
    2.  'A' (ace card) = 1
    3.  '2' - '10' = numerical value.
    """
    placeholder_6 = placeholder_0(placeholder_4)
    placeholder_7 = placeholder_0(placeholder_5)
    if placeholder_6 == placeholder_7:
        placeholder_8 = (placeholder_4, placeholder_5)
    elif placeholder_6 > placeholder_7:
        placeholder_8 = placeholder_4
    else:
        placeholder_8 = placeholder_5
    return placeholder_8

def placeholder_9(placeholder_4, placeholder_5):
    """Calculate the most advantageous value for the ace card.

    :param card_one, card_two: str - card dealt. See below for values.
    :return: int - either 1 or 11 value of the upcoming ace card.

    1.  'J', 'Q', or 'K' (otherwise known as "face cards") = 10
    2.  'A' (ace card) = 11 (if already in hand)
    3.  '2' - '10' = numerical value.
    """
    placeholder_6 = 11 if placeholder_4 == 'A' else placeholder_0(placeholder_4)
    placeholder_7 = 11 if placeholder_5 == 'A' else placeholder_0(placeholder_5)
    placeholder_10 = 1 if 11 + (placeholder_6 + placeholder_7) > 21 else 11
    return placeholder_10

def placeholder_11(placeholder_4, placeholder_5):
    """Determine if the hand is a 'natural' or 'blackjack'.

    :param card_one, card_two: str - card dealt. See below for values.
    :return: bool - is the hand is a blackjack (two cards worth 21).

    1.  'J', 'Q', or 'K' (otherwise known as "face cards") = 10
    2.  'A' (ace card) = 11 (if already in hand)
    3.  '2' - '10' = numerical value.
    """
    return (placeholder_4 == 'A' or placeholder_5 == 'A') and (placeholder_0(placeholder_4) == 10 or placeholder_0(placeholder_5) == 10)

def placeholder_12(placeholder_4, placeholder_5):
    """Determine if a player can split their hand into two hands.

    :param card_one, card_two: str - cards dealt.
    :return: bool - can the hand be split into two pairs? (i.e. cards are of the same value).
    """
    return placeholder_0(placeholder_4) == placeholder_0(placeholder_5)

def placeholder_13(placeholder_4, placeholder_5):
    """Determine if a blackjack player can place a double down bet.

    :param card_one, card_two: str - first and second cards in hand.
    :return: bool - can the hand can be doubled down? (i.e. totals 9, 10 or 11 points).
    """
    return 8 < placeholder_0(placeholder_4) + placeholder_0(placeholder_5) < 12
