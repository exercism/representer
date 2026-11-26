#!/usr/bin/env bash

main() {
    # 1. Convert input to lowercase
    local phrase="${1,,}"

    # 2. Strip everything except lowercase letters (removes spaces, hyphens, etc.)
    local letters="${phrase//[^a-z]/}"

    local seen=""
    local len=${#letters}

    # 3. Iterate through each letter and check if we've already seen it
    for (( i=0; i<len; i++ )); do
        local char="${letters:i:1}"

        if [[ "$seen" == *"$char"* ]]; then
            echo "false"
            return 0
        fi

        seen+="$char"
    done

    echo "true"
}

# Only execute main if run directly from the command line
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi