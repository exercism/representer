#!/usr/bin/env bash

main() {
    declare -ir target="$1"
    shift
    declare -ar arr=("$@")
    declare -i lo=0 hi=$(($# + 1)) mid midval

    while ((lo <= hi)); do
        mid=$(( (hi + lo + 1) >> 1 ))
        midval=${arr[mid]}
        (( target == midval )) && {
            echo $mid
            return
        }
        (( target < midval )) && hi=$((mid - 1)) || lo=$((mid + 1))
    done
    echo -1
}

main "$@"
