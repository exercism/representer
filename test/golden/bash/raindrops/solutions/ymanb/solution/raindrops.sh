#!/usr/bin/env bash

# This option will make the script exit when there is an error
set -o errexit
# This option will make the script exit when it tries to use an unset variable
set -o nounset

main() {
  # A string variable containing only the FIRST argument passed to the script,
  # you can use input=$@ to get a string with ALL arguments
  input="$1"
  
  result=""

  if (( "$input" % 3 == 0 )); then 
	  result="Pling"
  fi
  if (( "$input" % 5 == 0 )); then
	  result+="Plang"
  fi
  if (( "$input" % 7 == 0 )); then
	  result+="Plong"
  fi
  if [[ "$result" == "" ]]; then
	  result="$input"
  fi
  
  echo "$result"
}

# Calls the main function passing all the arguments to it via '$@'
# The argument is in quotes to prevent whitespace issues
main "$@"
