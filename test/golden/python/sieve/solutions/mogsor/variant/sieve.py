# this one was fun :)


def primes(limit: int) -> list[int]:

    out: list[int] = []
    factors: set[int] = set([])

    for x in range(2, limit + 1):
        if x not in factors:
            for z in range(x - x, limit + 1, x):
                factors.add(z)
            out.append(x)

    return out
