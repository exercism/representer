#!/usr/bin/env bash

main() {
  local -a input output
  local -i row col
  
  [[ -t 0 ]] || readarray -t input

  # Make sure that every line is at least as long as the line after it
  for (( row = ${#input[@]} - 2; row >= 0; row-- )); do
    input[row]=$(printf "%-*s" ${#input[row+1]} "${input[row]}")
  done

  # Iterate through input and set up new lines based on the columns of the lines
  for (( row = 0; row < ${#input[@]}; row++ )); do
    for (( col = 0; col < ${#input[$row]}; col++ )); do
      output[$col]+=${input[$row]:col:1}
    done
  done
  
  # Output all the lines that were built up
  for line in "${output[@]}"; do
    echo "$line"
  done
}

main "$@"
# vim:ts=2:sw=2:expandtab
