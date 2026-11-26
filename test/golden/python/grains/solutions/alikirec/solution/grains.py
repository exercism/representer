NUMBER_OF_SQUARES = 8 * 8

def square(number):
    """
    Returns square of the given number
    """
    if not 1 <= number <= NUMBER_OF_SQUARES:
        raise ValueError("square must be between 1 and 64")
    
    return 2 ** (number - 1)


def total():
    total = 0
    
    return (2 ** NUMBER_OF_SQUARES) - 1
