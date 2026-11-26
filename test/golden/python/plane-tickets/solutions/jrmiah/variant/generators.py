"""Functions to automate Conda airlines ticketing system."""
SEAT_LETTERS = ["A", "B", "C", "D"]

def generate_seat_letters(number):
    """Generate a series of letters for airline seats.

    Parameters:
        number (int): Total number of seat letters to be generated.

    Returns:
        generator: A generator that yields seat letters.

    Note:
        Seat letters are generated from A to D.
        After D the sequence starts again with A.
        For example: A, B, C, D, A, B

    """
    current_seat_index = 0
    for _ in range(number):        
        if current_seat_index == 4:
            current_seat_index = 0
        yield SEAT_LETTERS[current_seat_index]
        current_seat_index += 1



def generate_seats(number):
    """Generate a series of identifiers for airline seats.

    Parameters:
        number (int): The total number of seats to be generated.

    Returns:
        generator: A generator that yields seat numbers.

    Note:
        A seat number consists of the row number and the seat letter.
        There is no row 13, and each row has 4 seats.

        Seats should be sorted from low to high.
        For example: 3C, 3D, 4A, 4B

    """
    current_row = 1
    seat_counter = 1
    seat_letter = generate_seat_letters(number)
    for _ in range(number):
        seat_number = str(current_row) + next(seat_letter)
        yield seat_number
        seat_counter += 1
        if seat_counter == 5:
            current_row += 1
            seat_counter = 1
        if current_row != 13:
            current_row += 1


def assign_seats(passengers):
    """Assign seats to passengers.

    Parameters:
        passengers (list[str]): A list of strings containing names of passengers.

    Returns:
        dict: With passenger names as keys and seat numbers as values.
        Example output: {"Adele": "1A", "Björk": "1B"}

    """
    number = len(passengers)
    assigned_seats = dict.fromkeys(passengers, "")
    seat_assigner = generate_seats(number)
    for name in passengers:
        assigned_seats[name] = seat_assigner.__next__()

    return assigned_seats


def generate_codes(seat_numbers, flight_id):
    """Generate codes for a ticket.

    Parameters:
        seat_numbers (list[str]): A list of seat numbers.
        flight_id (str): A string containing the flight identifier.

    Returns:
        generator: A generator that yields 12 character long ticket codes.

    """
    for seat in seat_numbers:
        unique_code = seat + flight_id
        fill_in = 12 - len(unique_code)
        ticket_code = unique_code + "0" * fill_in
        yield ticket_code