#!/usr/bin/env bash

countSum() {
    points=0

    for ((i = 2; i <= $#; i++)); do
        curr=${!i}

        if [[ $curr -eq $1 ]]; then
            points=$(($points + $curr))
        fi
    done

    echo "$points"
}

yacht() {
    points=0
    total=$(($2 * 5))

    shift

    for i in "$@"; do
        points=$(($points + $i))
    done

    if [[ $points -eq $total ]]; then
        echo 50
    else
        echo 0
    fi
}

choice() {
    points=0

    shift

    while test ${#} -gt 0; do
        points=$(($points + $1))
        shift
    done

    echo $points
}

fullHouse() {
    declare -a matches
    declare -a points
    total=0

    shift

    for i in "$@"; do
        matches[$i]=$((${matches[$i]} + 1))

        points[$i]=$((${points[$i]} + $i))
    done

    for key in "${!matches[@]}"; do
        val=${matches[$key]}

        if [[ $val -gt 1 && $val -lt 4 ]]; then
            total=$(($total + ${points[$key]}))
        fi
    done

    if [[ ${#matches[@]} -lt 3 ]]; then
        echo $total
    else
        echo 0
    fi
}

fourKind() {
    declare -a matches
    declare -a points
    total=0

    shift

    for i in "$@"; do
        matches[$i]=$((${matches[$i]} + 1))

        if [[ ${matches[$i]} -lt 5 ]]; then
            points[$i]=$((${points[$i]} + $i))
        fi
    done

    for key in "${!matches[@]}"; do
        val=${matches[$key]}

        if [[ $val -gt 3 ]]; then
            total=${points[$key]}
        fi
    done

    echo $total
}

lilStraight() {
    declare -a matches
    isStraight=true

    matches[1]=0
    matches[2]=0
    matches[3]=0
    matches[4]=0
    matches[5]=0

    shift

    for i in "$@"; do
        matches[$i]=$((${matches[$i]} + 1))
    done

    for val in "${matches[@]}"; do
        if [[ $val -lt 1 ]]; then
            isStraight=false
            break
        fi
    done

    if [[ $isStraight == true ]]; then
        echo 30
    else
        echo 0
    fi
}

bigStraight() {
    declare -a matches
    isStraight=true

    matches[2]=0
    matches[3]=0
    matches[4]=0
    matches[5]=0
    matches[6]=0

    shift

    for i in "$@"; do
        matches[$i]=$((${matches[$i]} + 1))
    done

    for val in "${matches[@]}"; do
        if [[ $val -lt 1 ]]; then
            isStraight=false
            break
        fi
    done

    if [[ $isStraight == true ]]; then
        echo 30
    else
        echo 0
    fi
}

main() {
    case "$1" in
    "ones")
        countSum 1 "$@"
        ;;
    "twos")
        countSum 2 "$@"
        ;;
    "threes")
        countSum 3 "$@"
        ;;
    "fours")
        countSum 4 "$@"
        ;;
    "fives")
        countSum 5 "$@"
        ;;
    "sixes")
        countSum 6 "$@"
        ;;
    "full house")
        fullHouse "$@"
        ;;
    "four of a kind")
        fourKind "$@"
        ;;
    "little straight")
        lilStraight "$@"
        ;;
    "big straight")
        bigStraight "$@"
        ;;
    "yacht")
        yacht "$@"
        ;;
    "choice")
        choice "$@"

        ;;
    *)
        echo "Invalid arguments"
        ;;
    esac

}

main "$@"

