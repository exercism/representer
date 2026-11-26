#!/usr/bin/env bash

main () {
    output=""
    if [[ $(( $1 % 3 )) -eq 0 ]]; then output+="Pling"
    fi
    if [[ $(( $1 % 5 )) -eq 0 ]]; then output+="Plang"
    fi
    if [[ $(( $1 % 7 )) -eq 0 ]]; then output+="Plong"
    fi

    if [[ -z $output ]]; then output=$1
    fi
    echo $output
}

main "$@"
