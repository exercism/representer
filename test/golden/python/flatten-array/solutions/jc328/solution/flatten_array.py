def flatten(iterable):

    out = []
    for item in iterable:
        if isinstance(item, list):
            out.extend(flatten(item))
        elif item is not None:
            out.append(item)
    return out



# arr = [1,[2,3,None,4],[[None]],5]
arr = [0, 2, [[2, 3], 8, 100, 4, [[[50]]]], -2]

print(flatten(arr))
