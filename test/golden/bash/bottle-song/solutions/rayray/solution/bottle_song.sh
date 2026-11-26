#!/usr/bin/env bash
readonly -a BOTTLES=(
    "no"
    "one"
    "two"
    "three"
    "four"
    "five"
    "six"
    "seven"
    "eight"
    "nine"
    "ten"
)

get_bottles() {
    echo -n "${BOTTLES[$1]} green bottle"
    (( $1 != 1 )) && echo -n "s"
    echo -n " hanging on the wall"
}

main() {
    if (( $# != 2 )); then
        echo "2 arguments expected"; exit 1
    elif (( $2 > $1 )); then
        echo "cannot generate more verses than bottles"; exit 1
    fi

    for (( i = $1; i > $1 - $2; i-- )); do
        tmp=$(get_bottles $i)
        yes "${tmp^}," | head -n 2
        echo "And if one green bottle should accidentally fall,"
        echo -e "There'll be $(get_bottles $(( i - 1 ))).\n"
    done
}

main "$@"
