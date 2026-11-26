#!/usr/bin/env bash

factors=('3 Pling' '5 Plang' '7 Plong')

for rule in "${factors[@]}"; do
	read factor newstr <<< $rule
	if (( $1 % "$factor" == 0 )); then
		output+=$newstr
	fi
done

if [[ -z "$output" ]]; then
	output=$1
fi

echo "$output"
