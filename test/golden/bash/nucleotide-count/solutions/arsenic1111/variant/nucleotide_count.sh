#!/usr/bin/env bash

# Produces the count of each nucleotide in the provided nucleotide string

function validate-input {
    ######################################## 
    # Program arguments should be exactly 1 string of letters ACGT
    # Arguments:
    #   All script inputs
    # Returns:
    #   1 on invalid inputs
    ########################################
    if (( $# != 1 )); then
        echo "Usage: nucleotide_cpunt <nucleotide-str>"
        exit 1
    fi;

    pattern="[^ACTG]"
    if [[ ${1^^} =~ $pattern ]]; then
        echo "Invalid nucleotide in strand"
        exit 1
    fi;
}

function char-counts {
    ########################################
    # Returns the number of each character are in the input string
    # Globals:
    #   counts: A mapping from characters to char counts
    # Arguments:
    #   An input string to count chars on
    ########################################
    for (( i = 0 ; i < ${#1} ; i++ )); do
        (( ++counts[${1:$i:1}] ))
    done
}

function print-counts {
    ########################################
    # Print the char counts in the provided ordering
    # Arguments:
    #   A char count array to print
    #   An ordering to print the chars in
    # Outputs:
    #   Chars & char counts, 1 char per line
    ########################################
    for char in "${ordering[@]}"; do
        echo "$char: ${counts[$char]}"
    done
}
    

function main {
    declare -Ai counts=([A]=0 [C]=0 [G]=0 [T]=0)
    declare -a ordering=(A C G T)

    validate-input "$@"
    char-counts "${1^^}"
    print-counts
}

main "$@"
