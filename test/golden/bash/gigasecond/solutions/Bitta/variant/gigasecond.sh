#!/usr/bin/env bash

main () {
    local epoch
    epoch=$(date -d "$1" +"%s")
    local after_gigasecond=$((epoch + 1000000001))
    printf '%(%Y-%m-%dT%H:%M:%S)T\n' "$after_gigasecond"
}

main "$@"