BEGIN {
    rows = 1
    FPAT = "[[:blank:]_|]{3}"
    ocr[" _ | ||_|"] = 0
    ocr["     |  |"] = 1
    ocr[" _  _||_ "] = 2
    ocr[" _  _| _|"] = 3
    ocr["   |_|  |"] = 4
    ocr[" _ |_  _|"] = 5
    ocr[" _ |_ |_|"] = 6
    ocr[" _   |  |"] = 7
    ocr[" _ |_||_|"] = 8
    ocr[" _ |_| _|"] = 9
}
/^$/ {
    print ""
    exit 0
}
length($0) % 3 != 0 {
    print "Number of input columns is not a multiple of three"
    exit 1
}
NR % 4 == 0 {
    rows++
    next
}
{
    for (i = 1; i < NF; i++) digit[rows][i] = digit[rows][i] $i
}
ENDFILE {
    if (NR % 4 != 0) {
        print "Number of input lines is not a multiple of four"
        exit 1
    }
    for (i = 1; i <= length(digit); i++) {
        for (j = 1; j <= length(digit[i]); j++) {
            out = out sprintf("%s",
                digit[i][j] in ocr ? ocr[digit[i][j]] : "?")
        }
        out = out ","
    }
    print substr(out, 1, length(out) - 1)
}