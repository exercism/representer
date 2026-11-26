func steps(number: int) -> int:
    if number <= 0:
        return ERR_INVALID_PARAMETER

    var n: int = 0
    while number != 1:
        if (number & 1) == 0:
            number =  number >> 1
        else:
            number = (number << 1) - number + 1

        n += 1

    return n