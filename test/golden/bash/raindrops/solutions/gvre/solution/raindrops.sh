#!/usr/bin/env bash

# Check for required arguments
if [ "$#" -ne 1 ]; then
    exit 1
fi

num=$1
out=""

# Validate argument
if ! [[ "$num" =~ ^[0-9]+$ ]]; then
    echo "Argument must be an int"
    exit 1
fi

# Pling
if [[ $(( "$num" % 3 )) == 0 ]]; then
    out="${out}Pling"
fi

# Plang
if [[ $(( "$num" % 5 )) == 0 ]]; then
    out="${out}Plang"
fi

# Plong
if [[ $(( "$num" % 7 )) == 0 ]]; then
    out="${out}Plong"
fi

if [ "$out" != "" ]; then
    echo "$out"
else
    echo "$num"
fi
