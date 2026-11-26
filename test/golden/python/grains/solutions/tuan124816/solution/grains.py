def square(number):     # find how many grains were on a given square

    if number not in range(1, 65):     # if the number smaller than 1 or larger than 64 ==> error
        raise ValueError("square must be between 1 and 64")
    return 2 ** (number - 1)

def total():    # find the total number of grains on the chessboard
    return 2 ** 64 - 1
