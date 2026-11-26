"""Functions for tracking poker hands and assorted card tasks."""
import typing as t


def get_rounds(number: int) -> t.List[int]:
    """Create a list containing the current and next two round numbers."""
    return list(range(number, number + 3))


def concatenate_rounds(rounds_1: t.List[int], rounds_2: t.List[int]) -> t.List[int]:
    """Concatenate two lists of round numbers."""
    return [*rounds_1, *rounds_2]


def list_contains_round(rounds: t.List[int], number: int) -> bool:
    """Check if the list of rounds contains the specified number."""
    return number in rounds


def card_average(hand: t.List[int]) -> float:
    """Calculate and returns the average card value from the list."""
    return sum(hand) / len(hand)


def approx_average_is_average(hand: t.List[int]) -> bool:
    """
    Return if an average is using (first + last index values ) OR
    ('middle' card) == calculated average.
    """
    return card_average(hand) in [
        card_average([hand[0], hand[-1]]),
        hand[int(len(hand) / 2)],
    ]


def average_even_is_average_odd(hand: t.List[int]) -> bool:
    """
    Return if the (average of even indexed card values) ==
    (average of odd indexed card values).
    """
    return card_average(hand[::2]) == card_average(hand[1::2])


def maybe_double_last(hand: t.List[int]) -> t.List[int]:
    """Multiply a Jack card value in the last index position by 2."""
    *hand, last = hand
    return [*hand, last * 2 if last == 11 else last]
