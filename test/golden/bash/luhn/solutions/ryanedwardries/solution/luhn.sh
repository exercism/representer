#!/usr/bin/env bash
string=$(echo "$1")
stringcheck=$(echo "$string" | tr -d [:blank:])
numcheck=$(echo "$string" | tr -d [:digit:] | tr -d [:blank:] )
if [[ -n "$numcheck" ]]
then
    echo "false"

elif [[ ${#stringcheck} -lt 2 ]]
then
    echo "false"
else    

luhnlist=()
luhnscore=0

if [[ ${#stringcheck} -eq 3 ]]
then
    doubles=$(echo "${stringcheck:1:1}")
    else
doubles=$(echo "$1" | tr -d [:blank:] | sed "s/\(.\)./\1/g" | sed -e 's/\(.\)/\1 /g')
fi
nondoubles=$(echo "$1" | tr -d [:blank:] | rev | sed "s/\(.\)./\1/g" | sed -e 's/\(.\)/\1 /g')

for i in $nondoubles
do
        luhnlist+=($i)
done

for i in $doubles
do
        num=$(echo "$i * 2" | bc)
        if [[ "$num" -gt 9 ]]
        then
                num=$(echo "$num - 9" | bc)
                luhnlist+=($num)
        else
                luhnlist+=($num)
        fi
done

for i in ${luhnlist[@]}
do
         luhnscore=$(echo "$luhnscore + $i" | bc)
done


if (( $luhnscore % 10 == 0 ))
then
        echo "true"
else
        echo "false"
fi

fi