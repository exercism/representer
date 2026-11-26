#!/usr/bin/env bash

# ----------------------------------------------------------------------------
# exercism.io
# Bash Track Exercise: rotational_cipher
# Contributed: Anthony J. Borla (ajborla@bigpond.com)
# ----------------------------------------------------------------------------

# Sourced 'ord' and 'chr' from:
# http://etutionlk.blogspot.com/2015/12/functions-for-ord-and-chr-in-bash-shell.html
function ord() {
    LC_CTYPE=C printf '%d' "'$1"
    return ${LC_CTYPE}
}

function chr() {
    [ "$1" -lt 256 ] || return 1
    printf "\\$(printf '%03o' "$1")"
}

# Convert $1 (text) into newtext as per CHARMAP
function convert() {
    local char cipher ciphertext=''
    # Convert text via traversal and calculation
    for i in $(seq 0 $((${#1}-1))) ; do
        char="${1:${i}:1}"
        # Distinguish uppercase, lowercase and other        
        if [[ "${char}" =~ [A-Z] ]] ; then
            cipher=$(chr $(( (($(ord ${char}) - 65 + ${2}) % 26) + 65 )))
        elif [[ "${char}" =~ [a-z] ]] ; then
            cipher=$(chr $(( (($(ord ${char}) - 97 + ${2}) % 26) + 97 )))
        else 
            cipher="${char}"
        fi
        ciphertext+="${cipher}"
    done

    # Emit ciphertext
    echo "${ciphertext}"
}
    
# Standard return values
ERROR='Invalid arguments; expected: <text> <n>'

# Expecting a non-empty string argument, and an integer agument
[ $# -ne 2 -o -z "${1}" -o -n "${2//[0-9]}"  ] \
    && { echo ${ERROR}; exit 1; } \
    || rotn=$(( ${2} % 26 ))

# Perform conversion
convert "${1}" ${rotn}
