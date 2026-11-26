#!/usr/bin/env bash

is_factor() {
  local n="$1"
  local f="$2"

  local result
  result=$(( n % f ))

  (( result == 0 ))
}

output=""
n="$1"

if is_factor "$n" 3; then
  output="${output}Pling"
fi
if is_factor "$n" 5; then
  output="${output}Plang"
fi
if is_factor "$n" 7; then
  output="${output}Plong"
fi

if [[ -z "$output" ]]; then
  output="$n"
fi

echo "$output"

