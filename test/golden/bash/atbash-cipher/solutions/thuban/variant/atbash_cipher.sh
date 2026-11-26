#!/usr/bin/env bash

cipher() {
  # Translates a given string using the atbash cipher
  input=$(cat)
  alphabet=$(echo {a..z} {0..9} | tr -d ' ')
  zetabet=$(echo {z..a} {0..9} | tr -d ' ')
  echo "$input" | tr "$alphabet" "$zetabet"
}

normalize() {
  # Normalizes a given string
  input=$(cat)           # Read from pipe
  input=${input//[ .,]/} # Remove punctuation and whitespace
  input=${input,,}       # Convert to lowercase
  echo "$input"
}

group() {
  # Groups strings into five letter subsets
  input=$(cat) # Read piped input
  l=${#input}
  format=""
  for ((i = 0; i < l; i++)); do
    if [[ $(((i + 1) % 6)) -eq 0 && $((i + 1)) -ne l ]]; then
      format+=${input:i:1}" "
    else
      format+=${input:i:1}
    fi
  done
  echo "$format"
}

main() {
  case "$1" in
  encode) echo "$2" | normalize | cipher | group ;;
  decode) echo "$2" | normalize | cipher ;;
  *) echo "Usage: $0 encode|decode 'text'" ;;
  esac
}

main "$@"
