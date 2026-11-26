#!/usr/bin/env bash

main () {
  target="$1"
  shift
  list=($@)

  # Check if list is empty
  [[ -z $list ]] && echo "-1" && exit 0
  # Check if target is in range
  (( $target < ${list[0]} || ${list[-1]} < $target )) && echo "-1" && exit 0

  r=${#list[@]}
  l=0
  m=$((r / 2))
  while (( l <= r)); do
    v=${list[$m]}
    if (( $v > $target )); then
      r=$((m-1))
    elif (( $v < $target )); then
      l=$((m+1))
    else
      echo $m
      exit 0
    fi
    m=$(( (r+l) / 2))
  done
  echo "-1"
}

main "$@"
