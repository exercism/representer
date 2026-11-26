import math

def is_not_prime(number):
    if number == 2:
        return False
    if number == 3:
        return False
    
    for d in range(2, int(math.sqrt(number))+1):
        if number % d == 0:
            return True
    return False

def prime(number):
    if number < 1:
        raise ValueError("there is no zeroth prime")
    prime_count = 0
    test_number = 2
    while prime_count < number:
        if not is_not_prime(test_number):
            prime_count += 1
        test_number += 1
    return test_number - 1
        