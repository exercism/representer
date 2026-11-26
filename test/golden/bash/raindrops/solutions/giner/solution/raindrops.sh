#!/bin/bash

set -o errexit
set -o nounset

main() {
	[[ $# -ne 1 ]] && exit 1
	
	local num=$1
	local str=""
	
	(( num % 3 == 0 )) && str+="Pling"
	(( num % 5 == 0 )) && str+="Plang"
	(( num % 7 == 0 )) && str+="Plong"
	
	echo "${str:-$num}"
}

main "$@"
