#!/usr/bin/env bash
declare -A num_spelled_out=(
                            [0]="no"
			    [1]="one"
			    [2]="two"
			    [3]="three"
			    [4]="four"
			    [5]="five"
			    [6]="six"
			    [7]="seven"
			    [8]="eight"
			    [9]="nine"
			    [10]="ten"
)

capitalize_first() {

    first=${1:0:1}
    echo "${first^^}${1:1}"
}

recite () {
    start_bottles="${1}"
    takedown="${2}"

    while [ "${takedown}" -gt 0 ]; do

	line="$(capitalize_first "${num_spelled_out[${start_bottles}]}")"
	line+=" green "
	[[ ${start_bottles} -gt 1 ]] && bottles="bottles" ||
		bottles="bottle"
	line+="${bottles} hanging on the wall,"

	echo "${line}"
	echo "${line}"
	echo "And if one green bottle should accidentally fall,"

	[[ ${start_bottles} -eq 2 ]] && bottles="bottle" ||
		bottles="bottles"
	line="There'll be "
	line+="${num_spelled_out[$(( start_bottles - 1 ))]} "
	line+="green ${bottles} hanging on the wall."

	echo "${line}"
	
	[[ ${takedown} -gt 1 ]] && echo ""

	(( start_bottles-- ))
	(( takedown-- ))
    done
}

print_usage () {
    echo "Usage: ${0} <start bottles> <takedown>"
}

main () {

    if [[ ${#} -ne 2 ]]; then
	echo "Error: 2 arguments expected."	
	print_usage && exit 1
    elif [[ ${1} -lt ${2} ]]; then
	echo "Error: cannot generate more verses than bottles."
	print_usage && exit 1
    elif [[ ${1} =~ [^0-9] ]] || [[ ${2} =~ [^0-9] ]]; then
	echo "Error: Invalid argument."
	print_usage && exit 1
    fi

    recite "${@}"
}

main "${@}"

exit 0
