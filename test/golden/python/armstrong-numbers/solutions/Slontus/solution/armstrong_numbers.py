def is_armstrong_number(number):
    armstrong = 0
    n = len(str(number))
    partial_number = number
    for _ in range(n):
        digit = partial_number % 10
        armstrong += digit ** n
        partial_number = partial_number // 10
    return armstrong == number

