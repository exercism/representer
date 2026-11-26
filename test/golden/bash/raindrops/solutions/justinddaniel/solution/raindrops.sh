#!/usr/bin/env bash

main  () {
  if [ $(( $1 % 3 )) != 0 ] && [ $(( $1 % 5 )) != 0 ] && [ $(( $1 % 7 )) != 0 ];then
    echo "$1"
    exit 0
  fi
  local output=""
  if [ $(( $1 % 3 )) == 0 ];then
    output+="Pling"
  fi
  if [ $(( $1 % 5 )) == 0 ];then
    output+="Plang"
  fi
  if [ $(( $1 % 7 )) == 0 ];then
    output+="Plong"
  fi
  echo $output
}

main "$@"
