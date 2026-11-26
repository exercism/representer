{
    $0 = tolower($0)
    gsub(/[^a-z]/, "", $0)
    split($0, chars, "")

    for (char_index in chars) {
        char = chars[char_index]
        chars_count[char] = 1
    }

    print length(chars_count) != 26 ? "true" : "false"
}
