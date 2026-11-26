#! /bin/bash

#########################
# Function Declarations
###
function die () {
  printf '%s\n' "${1:-generic error}"
  exit 1
}

function coprime () {
  local -i x=$1 y=$2
  [[ $y -gt 0 ]] && coprime $y $(( x % y )) || # recursion until y = 0
    (( x == 1 )) && return 0 || return 1
}

# make_maps: build maps for funcs 'encode' and 'decode'
function make_maps () {
  local -a alphabet # array to seed the maps
  for letter in {a..z}; do
    alphabet+=( $letter )
  done
  # i is 'x' and j is the result of 'E(x)'
  declare -i i j
  for i in {0..25}; do
    # E(x) = (ax + b) mod m
    j=$(( ( A * i + B ) % M ))
    TO_CIPH[${alphabet[i]}]=${alphabet[j]} # for func encode
    TO_ALPH[${alphabet[j]}]=${alphabet[i]} # for func decode
  done
}

# fmt: chunk the output in groups of 5 for encoding
function fmt () {
  while read -r -n5 chunk; do
    # don't add whitespace to the end
    [[ -z $chunk ]] && break
    output+=( "$chunk" )
  done <<< "$1"

  printf '%s\n' "${output[*]}"
}

function encode () {
  local trans
  while read -r -N1 char; do
    trans+="${char/[[:alpha:]]}" # add numbers
    trans+="${TO_CIPH[$char]}"   # add letters
  done <<< "$TEXT"
  fmt "$trans" # needs formatting
}

function decode () {
  while read -r -N1 char; do
    printf '%s' "${char/[[:alpha:]]}" # add numbers
    printf '%s' "${TO_ALPH[$char]}"   # add letters
  done <<< "$TEXT"
  printf "\n" # be nice to terminals
}
  
# Main
function main () {
  # declare keys and M for E(x) = (ax + b) mod m
  declare -ri A=$2 B=$3 M=26
  declare -rl ACTION="${1:-0}" TEXT="${4//[![:alpha:][:digit:]]/}"

  # check that a and m are coprime
  coprime $A $M || die 'a and m must be coprime.'

  # maps for the encode and decode functions
  declare -A TO_CIPH TO_ALPH
  make_maps
  # now make maps readonly
  declare -r TO_CIPH TO_ALPH

  case "$ACTION" in
    encode) encode ;;
    decode) decode ;;
         *)
            die "Usage: ${0} <encode/decode> a b text"
            ;;
  esac
}

########
# Begin
###
main "$@"
