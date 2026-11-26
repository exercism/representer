#!/usr/bin/env bash

IFS=","
read -r -a pos1 <<<"$2"
read -r -a pos2 <<<"$4"

row1="${pos1[0]}"
col1="${pos1[1]}"
row2="${pos2[0]}"
col2="${pos2[1]}"

((row1 < 0 || row2 < 0)) && echo "row not positive" && exit 1
((col1 < 0 || col2 < 0)) && echo "column not positive" && exit 1
((row1 > 7 || row2 > 7)) && echo "row not on board" && exit 1
((col1 > 7 || col2 > 7)) && echo "column not on board" && exit 1

((row1 == row2 && col1 == col2)) && echo "same position" && exit 1

if ((row1 == row2 || col1 == col2 || row1 - row2 == col1 - col2 || row1 - row2 == col2 - col1)); then
  echo true
else
  echo false
fi
