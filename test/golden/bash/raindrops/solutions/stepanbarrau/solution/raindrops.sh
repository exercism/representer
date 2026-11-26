#!/usr/bin/env bash

# This is a bash script template in order to help you quick start any script.
# It contains some sensible defaults, you can learn more by visiting:
# https://google.github.io/styleguide/shell.xml
#
# /!\ Please remove all the comments when you use this on other exercises

# This option will make the script exit when there is an error
set -o errexit
# This option will make the script exit when it tries to use an unset variable
set -o nounset

main() {
  local sound=""

  if [[ $(( $1 % 3 )) -eq 0 ]]; then 
  	sound="${sound}Pling"
  fi
  if [[ $(( $1 % 5 )) -eq 0 ]]; then
  	sound="${sound}Plang"
  fi
  if [[ $(( $1 % 7 )) -eq 0 ]]; then
  	sound="${sound}Plong"
  fi
  if [[ -z "$sound" ]]; then
    echo "$1"
  else
  	echo "$sound"
  fi
  # A string variable containing only the FIRST argument passed to the script,
  # you can use input="$@" to get a string with ALL arguments
  # Add your code here
}

# Calls the main function passing all the arguments to it via '$@'
# The argument is in quotes to prevent whitespace issues
main "$@"
