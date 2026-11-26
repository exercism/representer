def is_armstrong_number(number):
    string = str(number)
    sum = 0
    for char in string:
        sum += int(char)**len(string)
    return sum == number
