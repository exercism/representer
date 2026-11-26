EIGHT_BIT_MASK = 0x80
SEVEN_BIT_MASK = 0x7F


def encode_int(n: int) -> list[int]:
    bs_lst = [n & SEVEN_BIT_MASK]
    n >>= 7
    while n > 0:
        bs_lst.append(n & SEVEN_BIT_MASK | EIGHT_BIT_MASK)
        n >>= 7
    return bs_lst[::-1]


def encode(numbers: list[int]) -> list[int]:
    return sum((encode_int(n) for n in numbers), [])


def decode(bytes_: list[int]) -> list[int]:
    values: list[int] = []
    n: int = 0
    for i, byte in enumerate(bytes_):
        n = (n << 7) - (byte & SEVEN_BIT_MASK)
        if not byte & EIGHT_BIT_MASK:
            values.append(n)
            n = 0
        elif i == len(bytes_) - 1:
            raise ValueError("incomplete sequence")
    return values
