#!/usr/bin/env bash

input=$1
shift_value=$2

# Exit on Errors, Undefined Variables are Errors, Fail on Pipe Errors
set -euo pipefail

# Function to rotate an ASCII value
rotate_ascii() {
    local base=$1
    local ascii=$2
    local shift=$3
    echo $(( (ascii - base + shift) % 26 + base ))
}

# Function to convert an ASCII value to its corresponding character
ascii_to_char() {
    local ascii=$1
    printf "%b" "\\$(printf "%o" "$ascii")"
}

# Function to rotate a single character by its ASCII value
rotate_char() {
    local char=$1
    local shift=$2

    # Get the ASCII value of the character
    ascii=$(printf "%d" "'$char")

    if [[ $char =~ [a-z] ]]; then
        # Rotate lowercase characters (ASCII range 97-122)
        ascii_to_char "$(rotate_ascii 97 "$ascii" "$shift")"
    elif [[ $char =~ [A-Z] ]]; then
        # Rotate uppercase characters (ASCII range 65-90)
        ascii_to_char "$(rotate_ascii 65 "$ascii" "$shift")"
    else
        # Non-alphabet characters are not rotated
        printf "%s" "$char"
    fi
}

# Iterate over each character in the input string
for (( i=0; i<${#input}; i++ )); do
    rotate_char "${input:$i:1}" "$shift_value"
done

# Print a newline at the end
echo
