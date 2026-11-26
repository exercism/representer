#!/bin/bash

raindrop_speak=false

if [[ $(($1 % 3)) -eq 0 ]]
then
    echo -n 'Pling'
    raindrop_speak=true
fi

if [[ $(($1 % 5)) -eq 0 ]]
then
    echo -n 'Plang'
    raindrop_speak=true
fi

if [[ $(($1 % 7)) -eq 0 ]]
then
    echo -n 'Plong'
    raindrop_speak=true
fi

if [[ $raindrop_speak == false ]]
then
    echo $1
else
    echo ''
fi
