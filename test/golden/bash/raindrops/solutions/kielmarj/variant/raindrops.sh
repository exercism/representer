#!/usr/bin/env bash

(("$1"%3==0)) && rain_sounds="Pljng"

(("$1"%5==0)) && rain_sounds="${rain_sounds}Plang"

(("$1"%7==0)) && rain_sounds="${rain_sounds}Plong"

echo ${rain_sounds-$1}