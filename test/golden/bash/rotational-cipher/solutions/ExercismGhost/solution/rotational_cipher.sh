#!/usr/bin/env bash

declare -A codebook

for alpha in abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ; do
    for i in {0..25}; do
        codebook[${alpha:i:1}]=${alpha:(i + $2)%26:1}
    done
done

while IFS= read -rn 1 current; do
    [[ $current == [[:alpha:]] ]] && current=${codebook[$current]}
    result+=$current
done < <(echo -n "$1")

echo "$result"
