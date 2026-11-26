#!/usr/bin/env bash

# ----------------------------------------------------------------------------
# exercism.org
# Bash Track Exercise: difference_of_squares
# Contributed: Anthony J. Borla (ajborla@bigpond.com)
# ----------------------------------------------------------------------------

# Operations
sum_of_squares() {
    declare -i number=${1}
    declare -i sum_of_squares=$(( number * (number + 1) * (2 * number + 1) / 6 ))
    echo ${sum_of_squares}
}

square_of_sum() {
    declare -i number=${1} 
    declare -i sum=$(( number * (number + 1) * 2 )) 
    echo $(( sum * sum ))
}

difference() {
    declare -i number=${1}
    declare -i square_of_sum=$(square_of_sum ${number})
    declare -i sum_of_squares=$(sum_of_squares ${number})
    echo $(( square_of_sum - sum_of_squares ))
}

# Standard return values
ARGNUM_ERROR='Expecting 2 arguments: <operation> <number>'
ARG1_ERROR='Expecting operation string: sum_of_squares | square_of_sum | difference'
ARG2_ERROR='Expecting non-negative integer'

# Expecting two arguments, a string, and an integer
[ $# -ne 2 ] && { echo "${ARGNUM_ERROR}"; exit 1; }

# Ensure only valid operation string (function name) accepted
[ -z "${1}" ] || [[ "${1}" != +(sum_of_squares|square_of_sum|difference) ]] \
              && { echo "${ARG1_ERROR}"; exit 1; }

# Reject non-numeric, and negative numeric, values
[ -z "${2//[0-9]}" ] || { echo "${ARG2_ERROR}"; exit 1; }

# Execute requested operation on number
operation="${1}" ; number="${2}" ; ${operation} ${number}
