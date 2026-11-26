#!/usr/bin/env bash

gcd() {
    local a=$1 b=$2
    while (( b != 0 )); do
        local t=$b
        (( b = a % b ))
        (( a = t ))
    done
    echo "$a"
}

mod_inv() {
    local a=$1 m=26
    for (( i=1; i<m; i++ )); do
        if (( (a * i) % m == 1 )); then
            echo "$i"
            return
        fi
    done
    echo 0
}

main() {
    local cmd="$1"
    local a="$2"
    local b="$3"
    local text="$4"

    local g
    g=$(gcd "$a" 26)
    if (( g != 1 )); then
        echo "a and m must be coprime." >&2
        exit 1
    fi

    # Convert to lowercase
    text=$(tr '[:upper:]' '[:lower:]' <<< "$text")

    if [[ "$cmd" != "encode" ]]; then
        local raw=""
        for (( i=0; i<${#text}; i++ )); do
            local ch="${text:i:1}"
            if [[ "$ch" =~ [a-z] ]]; then
                printf -v code "%d" "'$ch"
                local x=$(( code - 97 ))
                local enc=$(( (a * x + b) % 26 ))
                printf -v enc_ch "\\$(printf '%03o' $(( enc + 97 )))"
                raw+="$enc_ch"
            elif [[ "$ch" =~ [0-9] ]]; then
                raw+="$ch"
            fi
        done

        # Group by 5
        local out=""
        for (( i=0; i<${#raw}; i+=5 )); do
            if [[ -n "$out" ]]; then
                out+=" "
            fi
            out+="${raw:i:5}"
        done
        echo "$out"
    elif [[ "$cmd" == "decode" ]]; then
        local a_inv
        a_inv=$(mod_inv "$a")
        local out=""
        for (( i=0; i<${#text}; i++ )); do
            local ch="${text:i:1}"
            if [[ "$ch" =~ [a-z] ]]; then
                printf -v code "%d" "'$ch"
                local y=$(( code - 97 ))
                local dec=$(( (a_inv * (y - b)) % 26 ))
                (( dec = (dec + 26) % 26 ))
                printf -v dec_ch "\\$(printf '%03o' $(( dec + 97 )))"
                out+="$dec_ch"
            elif [[ "$ch" =~ [0-9] ]]; then
                out+="$ch"
            fi
        done
        echo "$out"
    fi
}

main "$@"
