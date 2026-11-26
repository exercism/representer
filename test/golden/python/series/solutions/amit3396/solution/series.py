def slices(series, length):
    if not length:
        raise ValueError("slice length cannot be zero")
    elif length < 0:
        raise ValueError("slice length cannot be negative")
    elif not series:
        raise ValueError("series cannot be empty")
    elif len(series) < length:
        raise ValueError("slice length cannot be greater than series length")

    contiguousSubstrings = []
    for i in range(len(series) - length + 1):
        contiguousSubstrings.append(series[i:i+length])
    return contiguousSubstrings
