proc reverse* (str: string) : string =
    let n = str.len()
    if n < 2: return str

    result = ""
    for i in countdown(n-1,0):
        result.add(str[i])
