#!/usr/bin/env bash
main () {
ret=""
     (( $1%3 == 0 )) && ret+="Pling"
     (( $1%5 == 0 )) && ret+="Plang"
     (( $1%7 == 0 )) && ret+="Plong"
     [[ -z $ret ]] && ret="$1"
     echo "$ret"
}
   main "$@"
