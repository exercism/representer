# These variables are initialized on the command line (using '-v'):
# - num

BEGIN {
    sound[3]="Pling";sound[5]="Plang";sound[7]="Plong"
    for (factor in sound)
        if (num % factor == 0)
            out = out sound[factor]
    print (out ? out : num)
}