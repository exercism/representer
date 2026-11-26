# These variables are initialized on the command line (using '-v'):
# - num

BEGIN {
    result = ""
    if (num % 3 == 0) {
        result = "Pling"
    }
    if (num % 5 == 0) {
        result = sprintf("%sPlang", result)
    }
    if (num % 7 == 0) {
        result = sprintf("%sPlong", result)
    }
    if (result == "") {
        printf("%d", num)
    } else {
        printf("%s", result)
    }
}
