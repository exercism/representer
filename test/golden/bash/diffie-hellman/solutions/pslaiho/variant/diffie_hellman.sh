#!/usr/bin/env bash

# Random number between two values, both ends inclusive
rand () {
  echo "$(( "$1" + RANDOM % ("$2"+"$1"+1) ))"
}

# usage: calculate_key <g> <a> <b>
calculate_key () {
  echo "$1^$2%$3" | bc
}

main () {
  case "$1" in
    "privateKey") 
      rand 2 $(( "$2"-1 )) ;;
    "publicKey")
      calculate_key "$3" "$4" "$2";;
    "secret")
      calculate_key "$3" "$4" "$2";;
  esac
}

main "$@"
