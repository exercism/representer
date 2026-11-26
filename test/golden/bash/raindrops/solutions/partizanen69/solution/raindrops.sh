#!/usr/bin/env bash
num=$1
result=''
if (( $num % 3 == 0 )); then
	result="${result}Pling"
fi

if (( $num % 5 == 0 )); then
	result="${result}Plang"
fi

if (( $num % 7 == 0 )); then
	result="${result}Plong"
fi

if [[ $result == '' ]]; then
	result=$num
fi

echo $result
