#!/usr/bin/env bash

main () {
    local name=$1
    local pos=$2

    if [[ $pos == *11 || $pos == *12 || $pos == *13 ]]; then
        echo "$name, you are the ${pos}th customer we serve today. Thank you!"
        exit 0
    elif [[ $pos == *1 ]]; then
        echo "$name, you are the ${pos}st customer we serve today. Thank you!"
    elif [[ $pos == *2 ]]; then
        echo "$name, you are the ${pos}nd customer we serve today. Thank you!"
    elif [[ $pos == *3 ]]; then
        echo "$name, you are the ${pos}rd customer we serve today. Thank you!"
    else
        echo "$name, you are the ${pos}th customer we serve today. Thank you!"
    fi

}

main "$@"