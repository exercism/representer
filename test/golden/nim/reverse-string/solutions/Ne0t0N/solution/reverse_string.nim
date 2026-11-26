proc reverse*(input: string): string =
    for i in countdown(len(input) - 1, 0):
        result &= input[i]
