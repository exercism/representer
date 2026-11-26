def is_armstrong_number(number):
    number = str(number)
    exponent = len(number)
    addition = 0
    for digit in number:
        addition += int(digit) ** exponent
    return bool(addition == int(number))
