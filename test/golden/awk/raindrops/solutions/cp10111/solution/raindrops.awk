# These variables are initialized on the command line (using '-v'):
# - num

BEGIN {
message=""
    if (num % 3 == 0) {
        message=message"Pling" 
        }
    if (num % 5 == 0) {
        message=message"Plang"
        }
    if (num % 7 == 0) {
        message=message"Plong"
    }
    if (num % 3 != 0 && num % 5 != 0 && num % 7 != 0) {
        message=num
    }
    print message
}
