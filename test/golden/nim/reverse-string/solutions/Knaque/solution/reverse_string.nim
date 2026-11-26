from algorithm import nil

proc reverse*(s: string): string =
    if s == "":
        return ""
    var x: seq[char]
    for c in s:
        x.add(c)
    algorithm.reverse(x, 0, x.len-1)
    var o = ""
    for i in x:
        o = o & $i
    return o
