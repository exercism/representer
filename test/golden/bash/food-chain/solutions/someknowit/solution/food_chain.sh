#!/usr/bin/env bash

declare -ra objects=([1]=fly spider bird cat dog goat cow horse)
declare -rA second_lines=(
    ["spider"]="It wriggled and jiggled and tickled inside her."
    ["bird"]="How absurd to swallow a bird!"
    ["cat"]="Imagine that, to swallow a cat!"
    ["dog"]="What a hog, to swallow a dog!"
    ["goat"]="Just opened her throat and swallowed a goat!"
    ["cow"]="I don't know how she swallowed a cow!"
)

sing() {
    local -r swallowed="${objects[$1]}"
    local -r second_line="${second_lines[$swallowed]}"
    local -i i
    echo I know an old lady who swallowed a "$swallowed".
    [[ -z $second_line ]] || echo "$second_line"
    for ((i = $1; i < 8 && i > 1; i--)); do
        printf "She swallowed the %s to catch the %s" "${objects[$i]}" "${objects[$i - 1]}"
        ((i == 3)) && echo -n " that wriggled and jiggled and tickled inside her"
        echo "."
    done

    case $1 in
    8) echo "She's dead, of course!" ;;
    *) echo "I don't know why she swallowed the fly. Perhaps she'll die." ;;
    esac
}

main() {
    local -i i
    for ((i = "$1"; i < "$2"; i++)); do
        sing "$i"
        echo
    done
    sing "$2"
}

abort() {
    echo "$*"
    exit 1
}

(($# == 2)) || abort 2 arguments expected
(($1 <= $2)) || abort Start must be less than or equal to End
main "$@"
