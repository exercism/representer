# These variables are initialized on the command line (using '-v'):
# - num
BEGIN {
    if (! (num % 3)) { x = x "Pling" }
    if (! (num % 5)) { x = x "Plang" }
    if (! (num % 7)) { x = x "Plong" }
}
END {
   print x ? x : num
}
