#!/usr/bin/env bash
reverse_string() {
  string="$1"
  reversed=""
  length=${#string}
  for ((i=$length-1; i>=0; i--))
  do
    reversed="$reversed${string:$i:1}"
  done
  echo "$reversed"
}
reverse_string "$@"