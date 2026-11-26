import algorithm

proc reverse*(s:string): string =
    result = newStringOfCap(len(s))
    for c in reversed(s):
        add(result, c)
