#!/usr/bin/env bash

is_equilateral() {
  a="$1"
  b="$2"
  c="$3"
  if (( $(echo "$a==$b" | bc) == 1 )) && (( $(echo "$a==$c" | bc) == 1 )); then
    echo "true"
  else
    echo "false"
  fi
}

is_isosceles() {
  a="$1"
  b="$2"
  c="$3"
  if (( $(echo "$a==$b" | bc) == 1 )) || (( $(echo "$a==$c" | bc) == 1 )) || (( $(echo "$b==$c" | bc) == 1 )); then
    echo "true"
  else
    echo "false"
  fi
}

has_violating_sides() {
  a="$1"
  b="$2"
  c="$3"
  if (( $(echo "$a+$b<$c" | bc) == 1 )) || (( $(echo "$a+$c<$b" | bc) == 1 )) || (( $(echo "$b+$c<$a" | bc) == 1 )); then
    echo "true"
  else
    echo "false"
  fi
}

has_zero_as_side() {
  a="$1"
  b="$2"
  c="$3"
  if (( $(echo "$a==0" | bc) == 1 )) || (( $(echo "$b==0" | bc) == 1 )) || (( $(echo "$c==0" | bc) == 1 )); then
    echo "true"
  else
    echo "false"
  fi
}

is_good_triangle() {
  a="$1"
  b="$2"
  c="$3"
  if [[ $(has_violating_sides "$a" "$b" "$c") == "true" ]] || [[ $(has_zero_as_side "$a" "$b" "$c") == "true" ]] ; then
    echo "false"
  else
    echo "true"
  fi
}

main() {
  type="$1"
  a="$2"
  b="$3"
  c="$4"
  if [[ $(is_good_triangle "$a" "$b" "$c") == "false" ]]; then
    echo "false"
    return
  fi
  if [[ "$type" == "equilateral" ]]; then
    is_equilateral "$a" "$b" "$c"
  elif [[ "$type" == "isosceles" ]]; then
    is_isosceles "$a" "$b" "$c"
  else
    if [[ $(is_equilateral "$a" "$b" "$c") == "false" ]] && [[ $(is_isosceles "$a" "$b" "$c") == "false" ]]; then
      echo "true"
    else
      echo "false"
    fi
  fi
}

main "$@"
