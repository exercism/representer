import tables, strutils

proc transform*(data: Table[int, seq[char]]): Table[char, int] =
    for k, vs in data:
        for v in vs:
            result[v.toLowerAscii] = k