def steps(number):
    try:
        if number <= 0:
            raise ValueError
    except ValueError:
        raise ValueError("Only positive integers are allowed")

    num = 0
    while number != 1:
        if number % 2 == 0:
            number = int(number / 2)
            num += 1
        else:
            number = int(3 * number + 1)
            num += 1
    else:
        return num

