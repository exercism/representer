#!/bin/bash

divisible () {
    # Parameters:
    # @number
    # @divisor
    # If number%divisor == 0, returns 1, else 0

    if [ -z $1 ] || [ -z $2 ]; then
        exit 1
    fi

    let remainder="$1 % $2"

    if [ $remainder -eq 0 ]; then
        echo "1"
    else
        echo "0"
    fi

}

main () {
    if [ -z $1 ]; then
        exit 1
    fi

    output=""
    let divby3=$( divisible "$1" 3)
    let divby5=$( divisible "$1" 5)
    let divby7=$( divisible "$1" 7)
    factored="0"

    if [ $divby3 -eq "1" ]; then
        output=${output}$( echo "Pling" )
        factored="1"
    fi

    if [ $divby5 -eq "1" ]; then
        output=${output}$( echo "Plang" )
        factored="1"
    fi

    if [ $divby7 -eq "1" ]; then
        output=${output}$( echo "Plong" )
        factored="1"
    fi

    if [ $factored -eq "0" ]; then
        echo "$1"
    else
        echo "$output"
    fi

}

main "$@"