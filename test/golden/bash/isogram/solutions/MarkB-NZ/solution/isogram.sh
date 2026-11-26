#!/usr/bin/env bash

main () {
    local string=${1,,}
    string=${string//[ -]/}

    length1=$( echo "${string}" | fold -w1 | sort | uniq | wc -l )
    length2=$( echo "${string}" | fold -w1 | wc -l )

    if [[ ${length1} -eq ${length2} ]]; then
        echo "true"
        exit 0
    else
        echo "false"
        exit 0
    fi
}

main "$@"

