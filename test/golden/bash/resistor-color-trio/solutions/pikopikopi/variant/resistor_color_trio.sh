#!/bin/bash

declare -A color_values
color_values=([black]=0 [brown]=1 [red]=2 [orange]=3 [yellow]=4 [green]=5 [blue]=6 [violet]=7 [grey]=8 [white]=9)

# just take the first three elements and ignore others
user_input=("${1}" "${2}" "${3}")

# If the user input is not a valid resistor color then exit
[[ -z "${color_values[${user_input[0]}]}" || -z "${color_values[${user_input[1]}]}" && -z "${color_values[${user_input[2]}]}" ]] && echo "invalid color" && exit 1

function ohm_value {
    ohm=$(( "${1}" * 10 + "${2}" ))

    for (( i = 0; i < "${3}"; i++ )); do
        ohm=$(( "${ohm}" * 10 ))
    done

    result=""
    if [[ "${ohm}" -eq 0 ]]; then
        result="0 ohms"
    elif [[ "${ohm} % 1000000000" -eq 0 ]]; then
        result="$(( ohm/1000000000 )) gigaohms"
    elif [[ "${ohm} % 1000000" -eq 0 ]]; then
        result="$(( ohm/1000000 )) megaohms"
    elif [[ "${ohm} % 1000" -eq 0 ]]; then
        result="$(( ohm/1000 )) kiloohms"
    else
        result="${ohm} ohms"
    fi
    echo "${result}"
}

ohm_value "${color_values[${user_input[0]}]}" "${color_values[${user_input[1]}]}" "${color_values[${user_input[2]}]}"

exit 0

