#!/usr/bin/env bash

INVALID="Invalid number.  [1]NXX-NXX-XXXX N=2-9, X=0-9"

main() {
    if [[ $# -ne 1 ]]; then
        echo "Usage: phone_number.sh <number>" >&2
        exit 1
    fi

    local input="$1"

    # Check for letters
    if [[ "$input" =~ [a-zA-Z] ]]; then
        echo "$INVALID" >&2
        exit 1
    fi

    # Remove allowed punctuation: spaces, dashes, dots, parens, plus
    local cleaned=$(echo "$input" | tr -d ' ().+-')

    # Check for non-digit characters remaining
    if [[ "$cleaned" =~ [^0-9] ]]; then
        echo "$INVALID" >&2
        exit 1
    fi

    # Remove country code 1 if present
    if [[ ${#cleaned} -eq 11 ]]; then
        if [[ "${cleaned:0:1}" == "1" ]]; then
            cleaned="${cleaned:1}"
        else
            echo "$INVALID" >&2
            exit 1
        fi
    fi

    if [[ ${#cleaned} -ne 10 ]]; then
        echo "$INVALID" >&2
        exit 1
    fi

    if [[ "${cleaned:0:1}" =~ [01] ]]; then
        echo "$INVALID" >&2
        exit 1
    fi

    if [[ "${cleaned:3:1}" =~ [01] ]]; then
        echo "$INVALID" >&2
        exit 1
    fi

    echo "$cleaned"
}

main "$@"
