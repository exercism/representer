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
main () {
    local result="";
    
    if ! (($1 % 3))
    then
        result="${result}Pling"
    fi
    
    if ! (($1 % 5))
    then
        result="${result}Plang"
    fi
    
    if ! (($1 % 7))
    then
        result="${result}Plong"
    fi

    echo ${result:-$1}

# your main function code here
}
#
#   # call main with all of the positional arguments
main "$@"
#
# *** PLEASE REMOVE THESE COMMENTS BEFORE SUBMITTING YOUR SOLUTION ***
