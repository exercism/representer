#!/usr/bin/env bash

str=${1,,}
count=0

for ((idx=0; idx < ${#str}; idx++)); do

    case "${str:$idx:1}" in

        a|e|i|o|u|l|n|r|s|t)
            ((count += 1))
            ;;
        d|g)
            ((count += 2))
            ;;
        b|c|m|p)
            ((count += 3))
            ;;
        f|h|v|w|y)
            ((count += 4))
            ;;
        k)
            ((count += 5))
            ;;
        j|x)
            ((count += 8))
            ;;
        q|z)
            ((count += 10))
            ;;
    esac

done

echo $count
