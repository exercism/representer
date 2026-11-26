#!/usr/bin/env bash

# The following comments should help you get started:

usage () {
    echo "Usage: $0 <string1> <string2>"
    exit 1
}

if [[ "$#" == 2 ]]; then
    if [[ "${#1}" != "${#2}" ]];then 
        echo "strands must be of equal length"
        exit 1
    fi
#rts+=${str: -$i:1}
    count=0
    for (( i=0; i<"${#1}"; i++)); do
        if [[ "${1:$i:1}" != "${2:$i:1}" ]]; then
            ((count++))
        fi
    done 
    echo "$count"
    exit 0
else 
usage
fi












# *** PLEASE REMOVE THESE COMMENTS BEFORE SUBMITTING YOUR SOLUTION ***
