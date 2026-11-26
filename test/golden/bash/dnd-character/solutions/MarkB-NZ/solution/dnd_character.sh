#!/usr/bin/env bash

#    Associative array for character creation
declare -A character_abilities

modifier() {
    local score="$1"
    if [[ "$score" -lt 10  && $(( "$score" % 2 )) -ne 0 ]]; then
        echo $(( ("$score" - 11) / 2 ))
    else
        echo $(( ("$score" - 10) / 2 ))
    fi
}

generate() {
    declare -a abilities=("strength" "dexterity" "constitution" "intelligence" "wisdom" "charisma")
    declare -a rolls

    for skill in "${abilities[@]}"; do    
        local i=0 
        local value=0
        for i in {1..4}; do
            roll=$((1 + RANDOM % 6))
            rolls+=("$roll")
        done    
#        IFS=$'\n' sorted=($(sort -n <<<"${rolls[*]}"))
#        unset IFS
        mapfile -t sorted < <(printf '%s\n' "${rolls[@]}" | sort -n)
        for (( i=1; i<${#sorted[@]}; i++ )); do
            value=$(( value + sorted[i] ))
        done
        character_abilities+=(["$skill"]="$value")
        unset rolls
        echo "$skill $value"
    done
    
    echo "hitpoints $((10 + $(modifier "${character_abilities["constitution"]}")))"
}

main () {
    if [[ "$1" == "modifier" ]]; then
        modifier "$2"    
    elif [[ "$1" == "generate" ]]; then
        generate
    else
        echo "error"
        exit 1
    fi 
}
 
main "$@"
