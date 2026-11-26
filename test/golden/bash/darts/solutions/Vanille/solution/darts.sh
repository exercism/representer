#!/usr/bin/env bash

points=( 10 5 1 )
sq_rad=( 1 25 100 )

if [ "$#" -ne "2" ]; then
    echo "Bad arg count"
    exit 1
fi

num='^-?[0-9]+([.][0-9]+)?$'
if ! [[ "$1" =~ $num ]] || ! [[ "$2" =~ $num ]]; then
    echo "Malformed argument"
    exit 1
fi

x="($1)"
y="($2)"
sq_r="$( bc <<< "scale=4; $x * $x + $y * $y")"

for i in {0..2}; do
    if [[ "1" == "$( bc <<< "${sq_rad[$i]} >= $sq_r" )" ]]; then
        echo "${points[$i]}"
        exit 0
    fi
done

echo "0"
exit 0
