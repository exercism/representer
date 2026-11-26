function get_value (letter) {
    switch (letter) {
        case /[aeioulnrst]/:
            return 1
        case /[dg]/:
            return 2
        case /[bcmp]/:
            return 3
        case /[fhvwy]/:
            return 4
        case /k/:
            return 5
        case /[jx]/:
            return 8
        case /[qz]/:
            return 10
    }
}
{
    result = 0
    split(tolower($0), arr, "")
    for (i in arr) {
        result += get_value(arr[i])
    }
    print toupper($0) "," result
}