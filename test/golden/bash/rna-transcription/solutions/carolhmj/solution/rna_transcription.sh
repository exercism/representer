#!/usr/bin/env bash

set -o errexit
set -o nounset

strand=${1-""}
transcripted_strand=""

for (( i = 0; i < ${#strand}; i++ )); do
	transcripted_nucleotide=""
	case "${strand:i:1}" in
			C )
				transcripted_nucleotide="G"
				;;
			G )
				transcripted_nucleotide="C"
				;;
			T )
				transcripted_nucleotide="A"
				;;
			A )
				transcripted_nucleotide="U"
				;;
			* )
				echo "Invalid nucleotide detected."
				exit 1							
	esac
	transcripted_strand=$(echo "${transcripted_strand}${transcripted_nucleotide}") 
done

echo "${transcripted_strand}"