from math import isqrt
import typing


def primes(limit):
    if (limit < 2):
        return []
    
    checks: typing.List[bool] = [(i >= 2) for i in range(limit + 1)]

    for i in range(2, isqrt(limit) + 1):
        if checks[i]:
            for j in range(pow(i, 2), limit + 1, i):
                checks[j] = False
    
    numbers: typing.List[int] = [i for i, check in enumerate(checks) if check]

    return numbers
