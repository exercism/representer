#!/usr/bin/env bash

main () {
    if (( $1 >=1 && $1 <=64 )); then
        echo "scale=2; 2^($1 - 1)" | bc
    elif [[ $1 == "total" ]]; then
        echo "18446744073709551615"
    else
        echo "Error: invalid input"
        exit 1
    fi
}

main "$@"
