def classify(number):
    """ A perfect number equals the sum of its positive divisors.

    :param number: int a positive integer
    :return: str the classification of the input integer
    """
    if number <= 0:
        raise ValueError("Classification is only possible for positive integers.")
    aliquot_list = []
    for aliquot in range(1, number):
        if number % aliquot == 0:
            aliquot_list.append(aliquot)
    if number == sum(aliquot_list):
        return 'perfect'
    elif number > sum(aliquot_list):
        return 'deficient'
    elif number < sum(aliquot_list):
        return 'abundant'
