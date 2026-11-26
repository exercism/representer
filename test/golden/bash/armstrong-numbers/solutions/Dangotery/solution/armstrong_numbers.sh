#!/usr/bin/env bash

# The following comments should help you get started:
# - Bash is flexible. You may use functions or write a "raw" script.
#
# - Complex code can be made easier to read by breaking it up
#   into functions, however this is sometimes overkill in bash.
#
# - You can find links about good style and other resources
#   for Bash in './README.md'. It came with this exercise.
#
#   Example:
#   # other functions here
#   # ...
#   # ...
#
main () {
  finresult=0
  for (( i=0; i<${#1}; i++ )); do
    digit="${1:$i:1}"
    (( finresult += digit ** ${#1} ))
  done
  if [[ $finresult -eq $1 ]]; then
    echo "true"
  else
    echo "false"
  fi
}

main "$@"