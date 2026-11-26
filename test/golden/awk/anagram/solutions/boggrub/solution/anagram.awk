function is_anagram (target, word,      i, count, tchars, wchars) {
    if (length(target) != length(word)) return 0

    target = tolower(target)
    word = tolower(word)
    if (target == word) return 0
    
    if (word !~ "^[" target "]+$") return 0

    m = split(target, tchars, "")
    n = split(word, wchars, "")
    for (i = 1; i <= n; i++) {
        count[tchars[i]]++
        count[wchars[i]]--
    }    
    for (i in count) if (count[i] != 0) return 0

    return 1
}

is_anagram(key, $1) == 1 {
    print $1
}