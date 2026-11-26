# These variables are initialized on the command line (using '-v'):
# - num

BEGIN {
    res = ""
    if (num % 3 == 0 || num % 5 == 0 || num % 7 == 0) {
        if (num % 3 == 0)
            res = res "Pling"
        if (num % 5 == 0)
            res = res "Plang"
        if (num % 7 == 0)
            res = res "Plong"
    }
    else
        res = num
    print res
}
