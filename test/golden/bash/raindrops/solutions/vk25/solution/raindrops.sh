#!/usr/bin/env bash
set -o errexit
set -o nounset
main() {
    if ! (( $# && $1 > 0 )) ; then
        echo "Usage: ./raindrops <number>"
        exit 1
    fi
    local raindrops=""
    if ! (( ${1} % 3 )); then
        raindrops+="Pling"
    fi
    if ! (( ${1} % 5 )); then
        raindrops+="Plang"
    fi
    if ! (( ${1} % 7 )); then
        raindrops+="Plong"
    fi
    if [[ -z $raindrops ]]; then
        echo "$1"
    else
        echo "$raindrops"
    fi
}
main "$@"