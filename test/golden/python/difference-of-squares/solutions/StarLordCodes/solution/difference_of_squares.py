from math import pow


def square_of_sum(number):
    sum = ((number*(number+1)/2))
    square_of_sum_ans = pow(sum,2)
    return square_of_sum_ans


def sum_of_squares(number):
    sum_of_squares_ans = (number * (number+1) *((2*number)+1)/6)
    return sum_of_squares_ans


def difference_of_squares(number):
    return square_of_sum(number) - sum_of_squares(number)
