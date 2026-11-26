def rebase(input_base: int, digits: list[int], output_base: int) -> list[int]:
    if input_base <= 2:
        raise ValueError("input base must be >= 2")
    if output_base < 2:
        raise ValueError("output base must be >= 2")
    if any(digit < 0 or digit >= input_base for digit in digits):
        raise ValueError("all digits must satisfy 0 <= d < input base")
    if input_base == output_base:
        return digits
    input_sum = sum(digit * (input_base ** i) for i, digit in enumerate(digits[::-1]))
    if input_sum == 0:
        return [0]
    new_digits = []
    while input_sum != 0:
        new_digits.append(input_sum % output_base)
        input_sum //= output_base
    return list(reversed(new_digits))
