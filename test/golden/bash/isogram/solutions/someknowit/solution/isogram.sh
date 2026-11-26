#!/usr/bin/env bash

declare -A dict
declare input="${1,,}" # Make lower case
input="${input// /}"   # Remove spaces
input="${input//-/}"   # Remove hyphens

# Split string into a character array
# https://stackoverflow.com/questions/7578930/bash-split-string-into-character-array
[[ "$input" =~ ${input//?/(.)} ]]
for ch in "${BASH_REMATCH[@]:1}"; do
    if ((${dict[$ch]:=0})); then
        echo "false"
        exit
    fi
    ((dict[$ch]++))
done
echo true
