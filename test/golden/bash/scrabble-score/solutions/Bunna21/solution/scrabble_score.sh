#!/usr/bin/env bash

input=$1

result=0

for (( i=0; i<${#input}; i++ )); do
        char="${input:$i:1}"

        if [[ "$char" =~ [A-Za-z] ]]; then
                if [[ "$char" =~ [AEIOULNRSTaeioulnrst] ]]; then
                        (( result+=1 ))
                elif [[ "$char" =~ [DGdg] ]]; then
                        (( result+=2 ))
                elif [[ "$char" =~ [BCMPbcmp] ]]; then
                        (( result+=3 ))
                elif [[ "$char" =~ [FHVWYfhvwy] ]]; then
                        (( result+=4 ))
                elif [[ "$char" =~ [Kk] ]]; then
                        (( result+=5 ))
                elif [[ "$char" =~ [JXjx] ]]; then
                        (( result+=8 ))
                elif [[ "$char" =~ [QZqz] ]]; then
                        (( result+=10 ))
                else
                        (( result+=0 ))
                fi
        else
                (( result+=0 ))
        fi
done
echo "$result"