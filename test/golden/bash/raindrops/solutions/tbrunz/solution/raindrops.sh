#!/usr/bin/env bash
#
# Exercism.io Bash track: Raindrops exercise.
#

RESPONSE_STRING[3]="Pling"
RESPONSE_STRING[5]="Plang"
RESPONSE_STRING[7]="Plong"

main () {
    local INPUT=${1}
    local NO_DIVISORS=true
    local DIVISOR

    # Perform the divisor tests only if the input is an integer.
    if [[ "${INPUT}" =~ ^[0-9]+$ ]]; then

        for DIVISOR in ${!RESPONSE_STRING[@]}; do
            if (( INPUT % DIVISOR == 0 )); then
                unset NO_DIVISORS
                printf "%s" "${RESPONSE_STRING[ ${DIVISOR} ]}"
            fi
        done
    fi

    if [[ ${NO_DIVISORS} ]]; then
        printf "%s" "${INPUT}"
    fi
}

main "$@"
