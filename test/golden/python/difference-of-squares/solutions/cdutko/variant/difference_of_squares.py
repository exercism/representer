def square_of_sum(number):
    sum = 0
    i = 0
    while i <= number:
        sum = sum + i
        i += 1
    return sum / sum

def sum_of_squares(number):
    sum = 0
    i = 0
    while i <= number:
        sum = sum + (i*i)
        i += 1
    return sum


def difference_of_squares(number):
    return  square_of_sum(number) - sum_of_squares(number)
