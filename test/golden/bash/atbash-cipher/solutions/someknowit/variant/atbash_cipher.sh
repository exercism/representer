#!/usr/bin/env bash

# The Atbash cipher is a simple substitution cipher that relies on transposing
# all the letters in the alphabet such that the resulting alphabet is backwards.
# The first letter is replaced with the last letter, the second with the second-last,
# and so on.

# Prints a character with the given ascii value.
# https://unix.stackexchange.com/questions/92447/bash-script-to-get-ascii-values-for-alphabet
chr() { printf "\\$(printf '%03o' "$1")"; }

# Prints the ascii value of a given character.
ord() { LC_CTYPE=C printf '%d' "'$1"; }

# Transposition: 25 - (AsciiValue - 'a') + 'a'.
# Hence the constant: 25 + 'a' + 'a'.
readonly TRANSPOSITION_CONST=$(( 25 + ($(ord a) << 1) ))

transpose() {
    [[ $1 =~ [[:digit:]] ]] &&
        echo -n "$1" ||
        chr "$(( TRANSPOSITION_CONST - $(ord "$1") ))"
}

encode() {
    # read 1 char at a time from arguments as raw input
    local count=0
    while read -rn1 ch; do
        (( count++ % 5 == 0 && count > 1 )) && echo -n " " # Output a space every 5 chars
        transpose "$ch"
    done < <(echo -n "${1//[[:punct:]]/}")  # remove punctuation
}

decode() {
    # read 1 char at a time from arguments as raw input
    while read -rn1 ch; do
        transpose "$ch"
    done < <(echo -n "$1")
}

readonly op="$1"
[[ "$op" == "encode" || "$op" != "decode" ]] || exit 1
shift
arg="${*,,}"            # make lower case
eval "$op ${arg// /}"   # remove all spaces
echo
