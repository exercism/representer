#!/usr/bin/env bash
main () {
    # ${#var} returns the length of var
    # ${var:pos:N} returns N characters from pos onwards
    if [ $# -ne 2 ]; then
        echo "Usage: hamming.sh <string1> <string2>"
        exit 1
    fi

    if [[ ${#1} -eq ${#2} ]]; then
        diff=0
        for (( i=0; i<${#1}; i++ )); do
            [[ "${1:$i:1}" != "${2:$i:1}" ]] && ((diff=diff+1))
        done
        echo $diff
    else 
        echo "left and right strands must be of equal length"
        exit 1
    fi
}

# call main with all of the positional arguments
main "$@"
