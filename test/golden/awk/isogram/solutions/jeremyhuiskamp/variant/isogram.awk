{
    $0 = tolower($0)
    gsub(/[^a-z]/, "")
    split($0, chars, "")
    for (i = 1; i < length(chars); i++) {
        if (chars_seen[chars[i]]) {
            print "false"
            exit
        }
        chars_seen[chars[i]]++
    }
    print "true"
}
