#!/usr/bin/env bash

set -o errexit
set -o nounset

error(){
    echo "Usage: ./raindrops.sh  <number>"
    exit 1
}

isNumber(){
    if ! [[ "$1" =~ ^[0-9]+$ ]]; then
        error
    fi
}

main (){

    (( "$#" == 1 )) || error
    isNumber "$1"

    res=""

    (( "$1" % 3 == 0 )) && res+="Pling"
    (( "$1" % 5 == 0 )) && res+="Plang"
    (( "$1" % 7 == 0 )) && res+="Plong"

    [[ -z "$res" ]] && echo "$1" || echo "$res"
}

main "$@"