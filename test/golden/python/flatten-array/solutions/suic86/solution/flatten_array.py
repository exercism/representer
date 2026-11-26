def flatten(iterable):
    result = []
    for e in iterable:
        if isinstance(e, list):
            result.extend(flatten(e))
        elif e is not None:
            result.append(e)
    return result
