#!/usr/bin/env bash

out=""

(( $1 % 3 == 0 )) &&  out+="Pling"

(( $1 % 5 == 0 )) && out+="Plang"

(( $1 % 7 == 0 )) && out+="Plong"

[[ -z $out ]] && out=$1

echo "$out"
