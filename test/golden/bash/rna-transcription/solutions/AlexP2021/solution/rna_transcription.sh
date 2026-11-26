#!/usr/bin/env bash

main() {
	rna=''

	for ((i=0; i<"${#1}"; i++)); do
		case "${1:$i:1}" in
			'G') rna="${rna}C";;
			'C') rna="${rna}G";;
			'T') rna="${rna}A";;
			'A') rna="${rna}U";;
			*) echo "Invalid nucleotide detected." && exit 1;;
		esac
	done

	echo "$rna"
}

main "$@"
