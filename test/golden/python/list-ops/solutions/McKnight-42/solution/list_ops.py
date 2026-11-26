def append(list1, list2):
    if list1 and list2:
        return list1 + list2
    if list1:
        return list1
    return list2


def concat(lists):
    """Concatenate a list of lists into a single list."""
    result = []
    for lst in lists:
        result = append(result, lst)
    return result


def filter(function, lst):
    """Return a list of elements for which function(element) is True."""
    return [x for x in lst if function(x)]


def length(lst):
    return len(lst)


def map(function, lst):
    """Return a new list with function applied to each element."""
    return [function(x) for x in lst]


def foldl(function, lst, initial):
    """Left fold: (((initial op x0) op x1) op x2) ..."""
    result = initial
    for x in lst:
        result = function(result, x)
    return result


def foldr(function, lst, initial):
    result = initial
    for x in reversed(lst):
        result = function(result, x)  # <-- accumulator first, element second
    return result


def reverse(lst):
    return lst[::-1]
