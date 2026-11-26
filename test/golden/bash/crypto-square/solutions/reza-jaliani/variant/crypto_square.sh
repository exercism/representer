#!/usr/bin/env bash
set -euo pipefail

main() {
    local input="${1:-}"

    # normalize
    local cleaned
    cleaned="$(printf "%s" "$input" \
        | tr '[:upper:]' '[:lower:]' \
        | sed 's/[^a-z0-9]//g')"

    # empty?
    if [[ -z "$cleaned" ]]; then
        printf "\n"
        exit 0
    fi

    local n="${#cleaned}"

    # compute columns c
    local c r
    local sqrt
    sqrt=$(printf "%s" "$n" | awk '{printf "%.0f", sqrt($1)}')

    c=$sqrt
    if (( c * c < n )); then
        ((c++))
    fi

    # compute rows r
    r=$(( (n + c - 2) / c ))

    # build rows with padding
    local -a rows=()
    local i row
    for ((i=0; i<r; i++)); do
        row="${cleaned:i*c:c}"
        # pad to length c
        while (( ${#row} < c )); do
            row="$row "
        done
        rows+=("$row")
    done

    # read column-wise to build chunks
    local -a chunks=()
    local col j chunk

    for ((col=0; col<c; col++)); do
        chunk=""
        for ((j=0; j<r; j++)); do
            chunk="${chunk}${rows[j]:col:1}"
        done
        chunks+=("$chunk")
    done

    # join with spaces
    printf "%s\n" "${chunks[*]}"
}

main "$@"
