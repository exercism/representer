# These variables are initialized on the command line (using '-v'):
# - num

BEGIN {
    sound = ""
    if(0 == num % 3)
        sound = sound "Pling"
    if(0 == num % 5)
        sound = sound "Plang"
    if(0 == num % 7)
        sound = sound "Plong"
    if(sound == "")
        sound = num
    print sound
    exit 0
}
