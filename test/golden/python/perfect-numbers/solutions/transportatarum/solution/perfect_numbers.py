"""
Perfect numbers problem at exercism.com
"""

def classify(number):
    """
    Determine if a number is perfect, abundant, or deficient
    based on Nicomachus' classification scheme for positive integers.

    Nicomachus devised a classification scheme for positive integers,
    identifying each as belonging uniquely to the categories of
    **perfect**, **abundant**, or **deficient**
    based on their aliquot sum.

    The aliquot sum is defined as the sum of the factors of a number
    not including the number itself.
    For example, the aliquot sum of 15 is (1 + 3 + 5) = 9

    Args:
        number ([int]): [description]

    Raises:
        ValueError: [positive integers accepted only]

    Returns:
        [str]: [return perfect, abundant or deficient as a string based on the sum of the divisors]
        perfect: aliquot sum = number
        abundant: aliquot sum > number
        deficient: aliquot sum < number
    """

    if number <= 0:
        raise ValueError("Classification is only possible for positive integers.")

    sum_of_divisors = 0

    for divisor in range(1, number):
        if (number % divisor) == 0:
            sum_of_divisors += divisor

    if sum_of_divisors == number:
        return "perfect"
    if sum_of_divisors > number:
        return "abundant"
    return "deficient"
