proc reverse*(input: string): string = 
    var output = input
    let str_len = input.len - 1
    for i in countup(0, str_len):
        output[i] = input[str_len - i]
    output
