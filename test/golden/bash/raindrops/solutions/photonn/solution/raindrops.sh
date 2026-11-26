#!/usr/bin/env bash

# The following comments should help you get started:
# - Bash is flexible. You may use functions or write a "raw" script.
#
# - Complex code can be made easier to read by breaking it up
#   into functions, however this is sometimes overkill in bash.
#
# - You can find links about good style and other resources
#   for Bash in './README.md'. It came with this exercise.
#
#   Example:
#   # other functions here
#   # ...
#   # ...
#
#   main () {
#     # your main function code here
#   }
#
#   # call main with all of the positional arguments
#   main "$@"
#
# *** PLEASE REMOVE THESE COMMENTS BEFORE SUBMITTING YOUR SOLUTION ***

main () {
    if [ $# -eq 1 ]
        then
            getFactor $1
            exit 0
        else
            echo "Usage: ./raindrops.sh number"
            exit 1
    fi
}

getFactor () {
    factorResult=""
    if [ $(($1%3)) -eq 0 ]; then
        factorResult=$factorResult"Pling"
    fi
    if [ $(($1%5)) -eq 0 ]; then
        factorResult=$factorResult"Plang"
    fi
    if [ $(($1%7)) -eq 0 ]; then
        factorResult=$factorResult"Plong"
    fi
    if [ -z $factorResult ]; then
        echo $1
    else
        echo $factorResult
    fi
}

main "$@"