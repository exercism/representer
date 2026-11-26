#!/usr/bin/env bash

set -o errexit  # Exit script when there is an error.
set -o nounset  # Exit script when it tries to use an unset variable.

make_it_rain() {
    number=${1}
    sound_of_three="Pling"
    sound_of_five="Plang"
    sound_of_seven="Plong"
    rain_sound=""
    if (( ${number} % 3 == 0 )); then
        rain_sound+=${sound_of_three}
    fi
    if (( ${number} % 5 == 0 )); then
        rain_sound+=${sound_of_five}
    fi
    if (( ${number} % 7 == 0 )); then
        rain_sound+=${sound_of_seven}
    fi
    if [[ -z "${rain_sound}" ]]; then
        echo "${number}"
    else
        echo "${rain_sound}"
    fi
}

main() {
    input=${1:-}
    # If argument is an integer, make it rain.
    if [[ -z "${input//[0-9]}" ]] && [[ -n "${input}" ]]; then
        make_it_rain "${1}"
    fi
}

main "$@"

