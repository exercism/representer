#!/usr/bin/env bash

series="$1"
length=${#series}
sublen="$2"

if [[ $length -eq 0 ]] ; then
    >&2 echo "series cannot be empty"
    exit 1
elif [[ "$sublen" -gt $length ]] ; then
    >&2 echo "slice length cannot be greater than series length"
    exit 1
elif [[ "$sublen" -le 0 ]] ; then
    sign="negative"
    if [[ "$sublen" -eq 0 ]] ; then
        sign="zero"
    fi
    >&2 echo "slice length cannot be $sign"
    exit 1
fi

output="${series:0:$sublen}"

for ((i=1; i<length - (sublen - 1); i++)) ; do
    output="$output ${series:i:$sublen}"
done

echo "$output"