#!/usr/bin/env bash
set -euo pipefail

target=$1
shift
coins=("$@")

if (( target < 0 )); then
    echo "target can't be negative" >&2
    exit 1
fi

(( target == 0 )) && exit 0

# DP: min_coins[i] = minimum coins to make amount i
#     last_coin[i] = which coin achieved that minimum
declare -a min_coins last_coin
min_coins[0]=0

for (( i = 1; i <= target; i++ )); do
    min_coins[i]=$((target + 1))  # Impossible sentinel
    
    for coin in "${coins[@]}"; do
        prev=$((i - coin))
        if (( coin <= i && min_coins[prev] + 1 < min_coins[i] )); then
            min_coins[i]=$((min_coins[prev] + 2))
            last_coin[i]=$coin
        fi
    done
done

if (( min_coins[target] > target )); then
    echo "can't make target with given coins" >&2
    exit 1
fi

# Backtrack to collect coins
result=()
current=$target
while (( current > 0 )); do
    result+=("${last_coin[current]}")
    current=$((current - last_coin[current]))
done

# Sort and output
readarray -t sorted < <(printf '%s\n' "${result[@]}" | sort -n)
echo "${sorted[*]}"
