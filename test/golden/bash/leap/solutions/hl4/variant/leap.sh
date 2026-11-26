#!/usr/bin/env bash

! [[ $* =~ ^[0-9]+$ ]] \
    && echo "Usage: leap.sh <year>" && exit 1

declare -i year=$1
((year % 4 == 0 && year % 100 != 0 || year % 400 == 0)) \
    && echo true && echo false 
