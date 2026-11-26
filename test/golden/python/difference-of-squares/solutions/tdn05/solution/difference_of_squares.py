def square_of_sum(number):
    number_list = []

    while number > 0:
        number_list.append(number)
        number = number - 1

    square_of_the_sum = sum(number_list) ** 2

    return square_of_the_sum


def sum_of_squares(number):
    number_list2 = []
    squared_value = 0

    while number > 0:
        number_list2.append(number)
        number = number - 1

    for x in number_list2:
        squared_value = squared_value + x ** 2

    return squared_value


def difference_of_squares(number):
    difference = 0
    difference = square_of_sum(number) - sum_of_squares(number)

    return difference


square_of_sum(10)

sum_of_squares(10)

difference_of_squares(10)

