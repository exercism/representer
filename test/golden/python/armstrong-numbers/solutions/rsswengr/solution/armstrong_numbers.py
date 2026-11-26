
def is_armstrong_number(number: int) -> bool:
    """
    Determines whether a number is an Armstrong number.

    Args:
        number (int): The given number.

    Returns:
        True if it's a Armstrong number, False otherwise.
    """
    digits = str(number)
    sum = 0

    for digit in digits:
        sum += int(digit) ** len(digits)

    return sum == number
