#!/usr/bin/env bash

main () {
     if [ "$1" = "total" ]; then #check whether input is equal to total or not
       bc <<< "2^64-1"           #Command line calculator to calculate total number of grains in chess board
     else
       if [[ "$1" -lt 1 || "$1" -gt 64 ]]; then #checks whether number is valid or not
        echo "Error: invalid input"
        exit 1
       fi
       val=$(($1-1))            
       bc <<<  "2^${val}"	#Command line calculator to calculate number of grains in particular block
     fi
}

main "$@"
