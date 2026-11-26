def score(x, y):
    hypotenuse = (x ** 2 + y ** 2) ** 0.5
    if hypotenuse <= 1:
        score = 10
    elif hypotenuse <= 5:
        score = 5
    elif hypotenuse <= 10:
        score = 1
    else:
        score = 0

    return score