#!/usr/bin/env bash

set -o errexit
set -o nounset

main() {
    num=$1
    sound=''

    if (( $num % 3 == 0 )); then       
       sound+="Pling"
    fi
    if (( $num % 5 == 0 )); then       
       sound+="Plang"
    fi
    if (( $num % 7 == 0 )); then       
       sound+="Plong"
    fi
    if [[ -z "$sound" ]]; then
       sound="$1"
    fi  
    echo "$sound"           
}

main "$@"
