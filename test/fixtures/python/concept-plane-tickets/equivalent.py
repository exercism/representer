"""Functions to automate Conda airlines ticketing system."""
import math
placeholder_0 = ['A', 'B', 'C', 'D']

def placeholder_1(placeholder_2):
    """Generate a series of letters for airline seats.

    :param number: int - total number of seat letters to be generated.
    :return: generator - generator that yields seat letters.

    Seat letters are generated from A to D.
    After D it should start again with A.

    Example: A, B, C, D

    """
    for placeholder_3 in range(placeholder_2):
        yield placeholder_0[placeholder_3 % 4]

def placeholder_4(placeholder_2):
    """Generate a series of identifiers for airline seats.

    :param number: int - total number of seats to be generated.
    :return: generator - generator that yields seat numbers.

    A seat number consists of the row number and the seat letter.

    There is no row 13.
    Each row has 4 seats.

    Seats should be sorted from low to high.

    Example: 3C, 3D, 4A, 4B

    """
    placeholder_2 = placeholder_2 + 4 if placeholder_2 >= 13 else placeholder_2
    placeholder_5 = placeholder_1(placeholder_2)
    for placeholder_3 in range(placeholder_2):
        placeholder_6 = math.ceil((placeholder_3 + 1) / 4)
        if placeholder_6 != 13:
            yield f'{str(placeholder_6)}{next(placeholder_5)}'

def placeholder_7(placeholder_8):
    """Assign seats to passengers.

    :param passengers: list[str] - a list of strings containing names of passengers.
    :return: dict - with the names of the passengers as keys and seat numbers as values.

    Example output: {"Adele": "1A", "Björk": "1B"}

    """
    placeholder_2 = len(placeholder_8)
    placeholder_9 = {}
    for placeholder_10, placeholder_11 in zip(placeholder_8, placeholder_4(placeholder_2)):
        placeholder_9[placeholder_10] = placeholder_11
    return placeholder_9

def placeholder_12(placeholder_13, placeholder_14):
    """Generate codes for a ticket.

    :param seat_numbers: list[str] - list of seat numbers.
    :param flight_id: str - string containing the flight identifier.
    :return: generator - generator that yields 12 character long ticket codes.

    """
    for placeholder_3 in placeholder_13:
        placeholder_15 = f'{placeholder_3}{placeholder_14}'
        yield (placeholder_15 + '0' * (12 - len(placeholder_15)))
