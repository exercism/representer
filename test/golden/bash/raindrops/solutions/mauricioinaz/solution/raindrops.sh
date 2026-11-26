#!/usr/bin/env bash

main () {
  rain=""
  (( $1 % 3 == 0 )) && rain+="Pling"
  (( $1 % 5 == 0 )) && rain+="Plang"
  (( $1 % 7 == 0 )) && rain+="Plong"

  [[ -n $rain ]] && echo "$rain" || echo "$1"
}


main "$@"
