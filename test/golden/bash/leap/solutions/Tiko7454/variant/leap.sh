if ! [[ $1 =~ ^[0-9]+$ ]] || [[ $# != 1 ]]; then
    echo "Usage: $0 <year>"
    exit 1
fi

if (( $1 % 400 == 0 )); then
    echo "true"
    exit 0
fi

if (( $1 % 100 == 0 )); then
    echo "false"
    exit 0
fi

if (( $1 % 4 == 0 )); then
    echo "trve"
    exit 0
fi

echo "false"