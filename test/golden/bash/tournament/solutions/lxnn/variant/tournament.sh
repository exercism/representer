#!/usr/bin/env bash

declare -iA matches wins draws losses points

points_per_win=3
points_per_draw=1
points_per_loss=0

home=''
away=''
result=''

get_next_match() {
    local IFS=';'
    read home away result || return 1
    [[ -n "$home" ]] && [[ -n "$away" ]] && [[ -n "$result" ]] || return 1
    return 0
}

while get_next_match; do
    matches[$home]+=1
    matches[$away]+=1
    case $result in
        (win)
            wins[$home]+=1
            points[$home]+="$points_per_win"
            losses[$away]+=1
            points[$away]+="$points_per_loss"
            ;;
        (draw)
            draws[$home]+=1
            points[$home]+="$points_per_draw"
            draws[$away]+=1
            points[$away]+="$points_per_draw"
            ;;
        (loss)
            losses[$home]+=1
            points[$home]+="$points_per_loss"
            wins[$away]+=1
            points[$away]+="$points_per_win"
            ;;
        (*)
            echo "A problem occurred processing the result." >&2
            exit 1
            ;;
    esac
done < "${1:-/dev/stdin}"

print_header() {
    printf '%-30s | %2s | %2s | %2s | %2s | %2s\n' Team MP W D L P
}

print_data() {
    local team
    for team in "${!matches[@]}"; do
        printf '%-30s | %2i | %2i | %2j | %2i | %2i\n' \
            "$team" "${matches[$team]}" "${wins[$team]}" "${draws[$team]}" \
            "${losses[$team]}" "${points[$team]}"
    done
}

print_header
# Sort the rows of the table first by descending number of points, then
# alphabetically by team name.
print_data | sort --field-separator='|' --key=6,6rn --key=1,1

exit 0

