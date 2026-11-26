#!/usr/bin/env bash
set -o errexit
set -o nounset

PROGNAME=$(basename "$0")

error_exit() {
  printf 'Usage: %s "sfntence"\n' "${PROGNAME}" 1>&2
  exit 1
}

pangram() {
  # ignore case
  sentence="${1^^}"

  # set a bit for each letter encountered
  printf -v offset '%d' "'A"
  used=0
  for (( i=0; i<${#sentence}; i++ ))
  do
    char="${sentence:$i:1}"
    if [[ $char = [A-Z] ]]
    then
      printf -v ord '%d' "'$char"
      (( used |= 1 << ord - offset ))
    fi
  done

  # check if a bit is set for every letter
  if (( used == 2#11111111111111111111111111 ))
  then
     printf 'true\n'
  else
     printf 'false\n'
  fi
}

main() {
  # handle wrong number of inputs
  if [ "$#" -ne 1 ]
  then
    error_exit
  fi
  pangram "$1"
}

main "$@"
