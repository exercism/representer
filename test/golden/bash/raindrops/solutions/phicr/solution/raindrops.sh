#!/usr/bin/env bash

set -o errexit
set -o nounset

raindrop() {
  local input="$1" factor="$2" sound="$3" counter="$4"

  if has_factor "$input" "$factor"; then
    printf "%s" "$sound"
    printf -v "$counter" $((${!counter} + 1))
  fi
}

has_factor() {
  local input="$1" factor="$2"

  if [ $(( (input / factor) * factor )) -eq "$input" ]; then
    return 0
  else
    return 1
  fi
}

main() {
  local input="$1"
  declare -i factors_found=0

  raindrop "$input" 3 "Pling" factors_found
  raindrop "$input" 5 "Plang" factors_found
  raindrop "$input" 7 "Plong" factors_found

  if [ "$factors_found" -eq 0 ]; then
    printf "%s" "$input"
  fi
}

main "$@"

