#!/usr/bin/env bash

main() {
    local N=$1
    local max_a=$(( (N - 3) * 3 ))

    for (( a=1; a<=max_a; a++ )); do
        local num=$(( N * (N - 2 * a) ))
        local den=$(( 2 * (N - a) ))

        if (( num % den == 0 )); then
            local b=$(( num / den ))
            if (( b > a )); then
                local c=$(( N - a - b ))
                if (( c > b )); then
                    echo "$a,$b,$c"
                fi
            fi
        fi
    done
}

main "$@"
