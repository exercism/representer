#!/usr/bin/env bash

declare -A symbols

if [[ -z "${*}" ]]; then
  echo true
  exit
fi

for symbol in "${@,,}"; do
  for ((i = 0; i < "${#symbol}"; i++)); do
    char=${symbol:$i:1}

    if [[ "${char}" =~ [a-z] ]]; then
      symbols["${char}"]+=1
    fi;

  done
done

for i in "${symbols[@]}"; do
  if [[ $i -gt 1 ]]; then
    echo false
    exit
  fi
done

echo true
