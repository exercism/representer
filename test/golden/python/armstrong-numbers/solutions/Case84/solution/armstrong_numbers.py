def is_armstrong_number(number):
    number_string = str(number)
    sum = 0
    for n in number_string:
        sum += int(n) ** len(number_string)
    return sum == number
