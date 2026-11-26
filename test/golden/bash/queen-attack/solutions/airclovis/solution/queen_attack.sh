#!/usr/bin/env bash

# set -x

w_pos=()
b_pos=()

validate_positions() {
    if ((w_pos[0] < 0 || b_pos[0] < 0)); then
        echo "row not positive"
        exit 1
    fi
    if ((w_pos[0] > 7 || b_pos[0] > 7)); then
        echo "row not on board"
        exit 1
    fi
    if ((w_pos[1] < 0 || b_pos[1] < 0)); then
        echo "column not positive"
        exit 1
    fi
    if ((w_pos[1] > 7 || b_pos[1] > 7)); then
        echo "column not on board"
        exit 1
    fi

    if ((w_pos[0] == b_pos[0] && w_pos[1] == b_pos[1])); then
        echo "same position"
        exit 1
    fi
}

check_diagonals() {
    local w_pos_x=${w_pos[0]}
    local w_pos_y=${w_pos[1]}
    for ((i = w_pos_x, j = w_pos_y; i < 8 && j < 8; i++, j++)); do
        if ((i == b_pos[0] && j == b_pos[1])); then
            echo true
            exit 0
        fi
    done
    for ((i = w_pos_x, j = w_pos_y; i >= 0 && j < 8; i--, j++)); do
        if ((i == b_pos[0] && j == b_pos[1])); then
            echo true
            exit 0
        fi
    done
    for ((i = w_pos_x, j = w_pos_y; i < 8 && j >= 0; i++, j--)); do
        if ((i == b_pos[0] && j == b_pos[1])); then
            echo true
            exit 0
        fi
    done
    for ((i = w_pos_x, j = w_pos_y; i >= 0 && j > 0; i--, j--)); do
        if ((i == b_pos[0] && j == b_pos[1])); then
            echo true
            exit 0
        fi
    done
}

while getopts "w:b:" flag; do
    case $flag in
    w)
        IFS=',' read -r x y <<<"${OPTARG}"
        w_pos=("$x" "$y")
        ;;
    b)
        IFS=',' read -r x y <<<"${OPTARG}"
        b_pos=("$x" "$y")
        ;;
    *) echo "Invalid flags" && exit 1 ;;
    esac
done

validate_positions
((b_pos[0] == w_pos[0])) && echo true && exit 0
((b_pos[1] == w_pos[1])) && echo true && exit 0
check_diagonals

echo "false"
