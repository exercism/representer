# These variables are initialized on the command line (using '-v'):
# - num

BEGIN {
    res = ""
    
    if (num % 3 == 0) {
        res = res "Pling"
    }
    
    if (num % 5 == 0) {
        res = res "Plang"
    }
    
    if (num % 7 == 0) {
        res = res "Plong"
    }

    if (res == "") {
        res = num
    }

    printf("%s\n", res)
}
