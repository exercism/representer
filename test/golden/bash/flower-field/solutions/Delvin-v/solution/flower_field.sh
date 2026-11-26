#!/usr/bin/bash

wdt="${#1}"
rs="$#"

declare -a garden;
r=""
for ((i=0; i<=$((wdt+1)); i++));
do
    r="${r}0"
done

garden[0]="${r}"
garden[$((rs+1))]="$r"

for ((i=1; i<=$rs; i++));
do
    prev=${garden[$((i-1))]}   
    ip=$((i+1))
    cur=$(echo "0${!i}0" | sed 's/ /0/g; s/\*/1/g');
    if (test $i -lt $rs);
    then
        nxt=$(echo "0${!ip}0" | sed 's/ /0/g; s/\*/1/g');
    else
        nxt=${garden[$((i+1))]}
    fi
    #echo "$prev $cur $nxt"

    k=""
    
    for ((j=1; j<=$wdt; j++));
    do
        if (test ${cur:$j:1} -eq 0);
        then
            p=$((j-1))
            n=$((j+1))
            v=$(echo "${prev:$j:1}+${nxt:$j:1}+${cur:$p:1}+${cur:$n:1}+${prev:$p:1}+${prev:$n:1}+${nxt:$p:1}+${nxt:$n:1}" | bc);

            if (test $v -eq 0);
            then
                v=" "
            fi
        else
            v=$(echo "*")
        fi
        k="${k}${v}"
    done
    echo "$k"
    garden[$i]="$cur"
    #echo "${garden[@]}"
done