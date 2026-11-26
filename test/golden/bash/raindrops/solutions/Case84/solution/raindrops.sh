#!/bin/bash

drops=""
if [ $(($1%3)) -eq 0  ]
then
    drops="Pling"
fi
if [ $(($1%5)) -eq 0 ]
then
    drops="$drops""Plang"
fi
if [ $(($1%7)) -eq 0  ]
then
    drops="$drops""Plong"
fi
if [ ${#drops} -eq 0 ]
then
    echo "$1"
else
    echo $drops
fi
