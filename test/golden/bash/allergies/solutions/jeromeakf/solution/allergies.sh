#!/usr/bin/env bash

# The following comments should help you get started:
# - Bash is flexible. You may use functions or write a "raw" script.
#
# - Complex code can be made easier to read by breaking it up
#   into functions, however this is sometimes overkill in bash.
#
# - You can find links about good style and other resources
#   for Bash in './README.md'. It came with this exercise.
#
#   Example:
#   # other functions here
#   # ...
#   # ...
#
  main () {
    score=$1
    score=$(( score % 256 )) 
    if (( score >= 128 )); then
        score=$(( score - 128 ))
        allergens="cats $allergens"
    fi
    if (( score >= 64 )); then
        score=$(( score - 64 ))
        allergens="pollen $allergens"
    fi
    if (( score >= 32 )); then
        score=$(( score - 32 ))
        allergens="chocolate $allergens"
    fi
    if (( score >= 16 )); then
        score=$(( score - 16 ))
        allergens="tomatoes $allergens"
    fi
    if (( score >= 8 )); then
        score=$(( score - 8 ))
        allergens="strawberries $allergens"
    fi
    if (( score >= 4 )); then
        score=$(( score - 4 ))
        allergens="shellfish $allergens"
    fi
    if (( score >= 2 )); then
        score=$(( score - 2 ))
        allergens="peanuts $allergens"
    fi
    if (( score >= 1 )); then
        score=$(( score - 1 ))
        allergens="eggs $allergens"
    fi

    allergens=$(echo "$allergens" | xargs)

    if [[ "$2" == allergic_to ]]; then
        found=false
        for allergen in $allergens; do 
            if [[ "$allergen" == "$3" ]]; then
                found=true
                break
            fi
        done
        echo "$found"
    else
        echo "$allergens"
    fi
        
  }
#
#   # call main with all of the positional arguments
  main "$@"
