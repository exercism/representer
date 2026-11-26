#!/bin/bash

function sort_upper() {
    echo ${1^^} | grep -o . | sort
}

left=$(sort_upper $1)

for i in $2
do
    if [[ ${1^^} != ${i^^}  ]] && [[ $left == $(sort_upper $i) ]]
    then
        anagram+=" $i"
    fi
done

echo $anagram
