#!/usr/bin/env bash

chr() {
	[ "$1" -lt 256 ] || return 1
	printf '%b' "\\$(printf '%03o' "$1")"
}

ord() {
	LC_CTYPE=C printf '%d' "'$1"
}

rot_char() {
	local char
	declare -i rotation
	char=$1
	rotation=$2
	if [[ "$1" =~ [[:lower:]] ]]; then
		chr $((($(ord "$char") - $(ord 'a') + rotation) % 26 + $(ord 'a')))
	elif [[ "$1" =~ [[:upper:]] ]]; then
		chr $((($(ord "$char") - $(ord 'A') + rotation) % 26 + $(ord 'A')))
	else
		printf "%s" "$char"
	fi
}

rot() {
	local sentence
	declare -i rotation
	sentence=$1
	rotation=$2
	for ((i = 0; i < ${#sentence}; i++)); do
		rot_char "${sentence:i:1}" "$rotation"
	done
}

main() {
	local sentence
	declare -i rotation
	sentence=$1
	rotation=$2
	rot "$sentence" "$rotation"
}

main "$@"
