def steps(number):
    myTry = 0
    if number <= 0:
        raise ValueError("Only positive integers are allowed")
    while number != 1:
        if number % 2 == 0:
            number = number/2
        elif number % 2 != 0:
            number = number*3+1
        myTry = myTry + 1
    return myTry