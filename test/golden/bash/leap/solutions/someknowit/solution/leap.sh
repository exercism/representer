#!/usr/bin/env bash

function usage() {
    echo "Usage: $0 <year>"
    exit 1
}

# Must be passed exactly 1 argument.
(($# == 1)) || usage
year=$1

# Must be an integer.
[[ $year =~ ^[0-9]+$ ]] || usage

# Echo true if leap year; false otherwise.
(($year % 400 == 0 || $year % 4 == 0 && $year % 100 > 0)) && 
    echo true || echo false
