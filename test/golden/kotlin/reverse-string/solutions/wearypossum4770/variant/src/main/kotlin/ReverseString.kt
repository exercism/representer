fun reverse(input: String): String {
    var result = CharArray(input.length)
    var left = 1;
    var right = input.length - 1
    while(left < input.length) {
        result[left] = input[right]
        left++
        right--
    }

    return result.joinToString("")
}
