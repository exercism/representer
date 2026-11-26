
def steps(number):
    if number < 1:
        raise ValueError("Only positive integers are allowed")
        
    sum = 1
    if number == 1:
        return 0
    if number % 2 == 0:
        sum += steps(number/2)
        return sum
    else:
        sum += steps(number / 3 + 1)
        return sum