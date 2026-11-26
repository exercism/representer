proc binarySearch*(a: openArray[int], val: int): int =
    var b = a.low
    var e = a.high
    while b <= e:
        var c = int((e - b) / 2)
        if a[c] == val:
            return c
        elif a[c] < val:
            b = c + 1    
        else:
            e = c - 1
    return -1