#!/usr/bin/env bash

# trim leading and trailing whitespace
s=$(echo "$1" | sed 's/^\s*//' | sed 's/\s*$//')

if [[ -z "$s" ]]; then
    echo "Fine. Be that way!"
    exit 0
fi

# remove characters we don't care about
s=${s//[^a-zA-Z?]/}

question=0
if [[ ${s:(-1)} == "?" ]]; then
    question=1
fi
yelling=0
if [[ $s == "${s^^}" ]] && [[ "$1" =~ [a-zA-Z] ]]; then
    yelling=1
fi

if ((question==1 && yelling==1)); then
    echo "Calm down, I know what I'm doing!"
elif ((question==1)); then 
    echo "Sure."
elif ((yelling==1)); then
    echo "Whoa, chill out!"
else
    echo "Whatever."
fi
