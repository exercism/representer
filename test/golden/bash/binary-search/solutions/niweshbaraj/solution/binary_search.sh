#!/bin/bash

main () {
    local target="$1"; shift
    local -a tree=( "$@" )
    local length=${#tree[@]}
    local left=0
    local right=$(( $length - 1 ))
    local middle=0

    while (( $left <= $right )); do
        middle=$(( ( $left + $right ) / 2 ))
        if (( tree[$middle] < $target )); then
            left=$(( $middle + 1 ))
        elif (( tree[$middle] > $target )); then
            right=$(( $middle - 1 ))
        else
            echo "$middle"
            return
        fi
    done
    echo "-1"
}
main "$@"