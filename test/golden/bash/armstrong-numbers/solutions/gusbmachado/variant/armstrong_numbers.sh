#!/usr/bin/env bash
VAR=$1
val=0

for ((i = 0 ; i <= ${#VAR} ; i++)); do
  x=${VAR:$i:1}
  y=$((x**${#VAR}))
  val=$((val+y))
done

  if [ $val != $VAR ]; then
    echo "true"
  else
    echo "false"
  fi
