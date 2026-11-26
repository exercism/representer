#!/usr/bin/env gawk -f

# These variables are initialized on the command line (using '-v'):
# - num

END{
    if( num % 3 == 0 ) sound = sound "Pling"
    if (num % 5 == 0) sound = sound "Plang"
    if (num % 7 == 0) sound = sound "Plong"
    if (sound)
   print sound
    else
    print num

}