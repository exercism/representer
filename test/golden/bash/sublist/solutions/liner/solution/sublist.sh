#!/usr/bin/env bash

normalize() {
  cc1="${1//[^,]/}";
  cc2="${2//[^,]/}";
  arg1="${1//[\[\], ]/}";
  arg2="${2//[\[\], ]/}";
}

main () {
normalize "$1" "$2";

if (( ${#arg1} == ${#arg2} )) && (( ${#cc1} == ${#cc2} )); then
  # unequal || equal
  [[ "$arg1" == "$arg2" ]] && echo "equal" || echo "unequal";
elif (( ${#arg1} < ${#arg2})) && (( ${#cc1} != ${#cc2} )); then
  # sublist
  [[ "$arg2" == *"$arg1"* ]] && echo "sublist" || echo "unequal";
elif (( ${#arg1} > ${#arg2} )) && (( ${#cc1} != ${#cc2} )); then
  # superlist
  [[ "$arg1" == *"$arg2"* ]] && echo "superlist" || echo "unequal"; 
else
  echo "unequal";
fi

}
main "$@"