#!/usr/bin/env bash

generate() {
    prefix=(
        "first" "second" "third" "fourth" "fifth" "sixth"
        "seventh" "eighth" "ninth" "tenth" "eleventh" "twelfth"
    )
    things=(
        "a Partridge in a Pear Tree" "two Turtle Doves" "three French Hens"
        "four Calling Birds" "five Gold Rings" "six Geese-a-Laying"
        "seven Swans-a-Swimming" "eight Maids-a-Milking" "nine Ladies Dancing"
        "ten Lords-a-Leaping" "eleven Pipers Piping" "twelve Drummers Drumming"
    )
    n=$(($1 - 1))
    result="On the ${prefix[n]} day of Christmas my true love gave to me: "
    for i in $(seq "$n" -1 0); do
        if [[ $i -ne $n ]]; then
            result="$result, "
            if [[ $i -eq 0 ]]; then
                result="${result}and "
            fi
        fi
        result=$result${things[i]}
    done
    echo "$result."
}

for i in $(seq "$1" "$2"); do
    generate "$i"
done
