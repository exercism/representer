#!/usr/bin/env bash

main(){
    HammingDis=0
    length1=${#1}
    length2=${#2}

    if [ $length1 -ne $length2 ]; then
        echo "strands must be of equal length"
        exit 2
    fi

    for ((i=0; i<$length1; i++)); do
        if [ ${1:i:1} != ${2:i:1} ]; then
            HammingDis=$((HammingDis + 1))
        fi
    done
    echo "$HammingDis"
}

if [ $# != 2 ]; then
    echo "Usage: hamming.sh <string1> <string2>"
    exit 1
else
    main "$@"
fi