#!/usr/bin/env bash

failure() {
    echo " "
    exit 1
}

get_input() {
    input=($(echo $@))
}

add_zeros() {
    [[ ${colors[${1}]} == "" ]] && failure
    mult=${colors[${1}]}
    mult=$(echo 10^$mult | bc)
    value=$(echo ${value}*${mult} | bc)
    if [[ $value -gt 0 ]]; then
        div=$(echo $value%1000000000 | bc)
        if [[ $div -eq 0 ]]; then
            value=$(echo $value/1000000000 | bc)
            ohm="gigaohms"
        else
            div=$(echo $value%1000000 | bc)
            if [[ $div -eq 0 ]]; then
                value=$(echo $value/1000000 | bc)
                ohm="megaohms"
            else
                div=$(echo $value%1000 | bc)
                if [[ $div -eq 0 ]]; then
                    value=$(echo $value/1000 | bc)
                    ohm="kiloohms"
                else
                    ohm="ohms"
                fi
            fi
        fi
    else
        ohm="ohms"
    fi
    value="${value} ${ohm}"
}

create_dict() {
    colors=(
        [black]=0
        [brown]=1
        [red]=2
        [orange]=3
        [yellow]=4
        [green]=5
        [blue]=6
        [violet]=7
        [grey]=8
        [white]=9
    )

}

main() {
    declare -A colors
    declare -a input
    create_dict $@
    get_input $@
    value=""
    start=$(echo ${input[0]})
    [[ ${colors[$start]} == 0 ]] && start=1 || start=0
    [[ $start == 1 ]] && end=1 || end=2
    for i in ${input[@]:$start:$end}; do
        [[ ${colors[$i]} == "" ]] && failure || value="${value}${colors[$i]}"
    done
    [[ $# -gt 2 ]] && add_zeros $3
    [[ $value == "" ]] && failure || echo $value
}

main "$@"
