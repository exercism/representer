# These variables are initialized on the command line (using '-v'):
# - num

BEGIN {
    raindrops = ""
    if (num % 3 == 0)
        raindrops = raindrops "Pling"
    if (num % 5 == 0)
        raindrops = raindrops "Plang"
    if (num % 7 == 0)
        raindrops = raindrops "Plong"
    if (length(raindrops) > 0)
        print raindrops
    else
        print num
}
