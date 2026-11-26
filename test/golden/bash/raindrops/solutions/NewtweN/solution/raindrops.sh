#!/bin/bash
divisible=0
#Test the parameter to see if it divisible by 3.
if [[ $(($1%3)) -eq 0 ]]; then
    divisible=1
    echo -n "Pling"
fi
#Test the parameter to see if it is divisible by 5.
if [[ $(($1%5)) -eq 0 ]]; then
    divisible=1
    echo -n "Plang"
fi
#Test the parameter to see if it is divisible by 7.
if [[ $(($1%7)) -eq 0 ]]; then
    divisible=1
    echo -n "Plong"
fi

if [[ $divisible -eq 0 ]]; then
    echo "$1"
else 
    echo 
fi
