import math

def placeholder_0(placeholder_1):
    """Returns an unordered list of divisors for n (1 < number).

    :param number: int a positive integer
    :return: list of int divisors
    """
    for placeholder_2 in range(2, int(math.sqrt(placeholder_1)) + 1):
        if placeholder_1 % placeholder_2 == 0:
            yield placeholder_2
            if placeholder_2 * placeholder_2 != placeholder_1:
                yield (placeholder_1 // placeholder_2)

def placeholder_3(placeholder_1):
    """ A perfect number equals the sum of its positive divisors.

    :param number: int a positive integer
    :return: str the classification of the input integer
    """
    if placeholder_1 <= 0:
        raise ValueError('Classification is only possible for positive integers.')
    placeholder_4 = sum(placeholder_0(placeholder_1)) + (1 if placeholder_1 > 1 else 0)
    if placeholder_4 < placeholder_1:
        return 'deficient'
    elif placeholder_4 == placeholder_1:
        return 'perfect'
    else:
        return 'abundant'
