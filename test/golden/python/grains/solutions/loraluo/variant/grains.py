def square(number):
    number = int(number)
    
    if number == 1:
        return 1
    if number < 64 and number >= 1:
        return 2 ** (number - 1)
    else:
        raise ValueError("square must be between 1 and 64")



def total():
    sum = 0
    for i in range(1, 65):
        sum += square(i)
    return sum