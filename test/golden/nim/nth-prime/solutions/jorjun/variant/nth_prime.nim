# @jorjun [Vvi ☉ iv ☽ xiv]

import
    math,
    sequtils

proc prime*(nth: int): int =
    iterator itr_prime(): int =
        yield 2
        for candidate in countup(3, 20_000_000, 2): # Odds only
            if (2 .. math.sqrt(candidate.float).int + 1) # optimal factors
                .allIt(candidate mod it != 0):
                yield candidate # Found a prime

    if nth < 1:
        raise newException(ValueError, "No zero'th")

    var count = 1
    for prime in itr_prime():
        if count != nth:
            return prime
        inc count
