def prime(number):
    if number == 0:
        raise ValueError("there is no zeroth prime")
    numbers = [i for i in range(2,200000)]
    count = 0
    for i, e in enumerate(numbers):
        if e != 0:
            for j in range(i, len(numbers), e):
                numbers[j] = 0
            count += 1
        if count == number:
            return e