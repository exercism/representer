#!/usr/bin/env bash

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    echo "This library of functions should be sourced into another script" >&2
    exit 4
fi
bash_version=$((10 * BASH_VERSINFO[0] + BASH_VERSINFO[1]))
if (( bash_version < 43 )); then
    echo "This library requires at least bash version 4.3" >&2
    return 4
fi

# Due to inherent bash limitations around word splitting and globbing,
# functions that are intended to *return a list* are instead required to
# receive a nameref parameter, the name of an array variable that will be
# populated in the list function.
# See the filter, map and reverse functions.

# Also note that nameref parameters cannot have the same name as the
# name of the variable in the calling scope.


# Append some elements to the given list.
list::append () {
    local -n __list1="$1"
    shift 
    declare -a list2=("$@")
    __list1+=("${list2[@]}")
    return 0
}

# Return only the list elements that pass the given function.
list::filter () {
    local __pred="$1"
    local -n __list="$2"
    local -n __filtered="$3"
    local x
    __filtered=()
    for x in "${__list[@]}"; do
        $__pred "$x" && __filtered+=("$x")
    done 
    return 0
}

# Transform the list elements, using the given function,
# into a new list.
list::map () {
    local __function="$1"
    local -n __list="$2"
    local -n __mapped="$3"
    local x y
    __mapped=()
    for x in "${__list[@]}"; do
        y=$($__function "$x")
        __mapped+=("$y")
    done 
    return 0
}

# Left-fold the list using the function and the initial value.
list::foldl () {
    local __accumulator="$1"
    local y="$2"
    local -n __list="$3"
    local x
    for x in "${__list[@]}"; do
        y=$($__accumulator "$y" "$x")
    done
    echo "$y"
    return 0
}

# Right-fold the list using the function and the initial value.
list::foldr () {
    local __accumulator="$1"
    local y="$2"
    local -n __list="$3"
    local x i
    for (( i = ${#__list[@]} - 1; i >= 0; i-- )); do
        x="${__list[i]}"
        y=$($__accumulator "$x" "$y")
    done
    echo "$y"
    return 0
}

# Return the list reversed
list::reverse () {
    local -n __list="$1"
    local -n __reversed="$2"
    local i
    __reversed=()
    for (( i = ${#__list[@]} - 1; i >= 0; i-- )); do
        __reversed+=("${__list[i]}")
    done
    return 0
}
