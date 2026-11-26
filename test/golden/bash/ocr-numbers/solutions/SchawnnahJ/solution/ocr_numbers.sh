#!/usr/bin/env bash
error(){
echo "$1" && exit 1
}
decode(){
case $1 in
' _ | ||_|   ')output=0;;
'     |  |   ')output=1;;
' _  _||_    ')output=2;;
' _  _| _|   ')output=3;;
'   |_|  |   ')output=4;;
' _ |_  _|   ')output=5;;
' _ |_ |_|   ')output=6;;
' _   |  |   ')output=7;;
' _ |_||_|   ')output=8;;
' _ |_| _|   ')output=9;;
*)output=?;;
esac
echo $output
}
declare -a tab
lines=0
while read
do
        (( ${#REPLY} % 3 == 0 )) || error "Number of input columns is not a multiple of three"
        for(( i=0 ; i <= $(( ${#REPLY} / 3 )) ; i++ ))
        do
            tab[$i]+="${REPLY:$((3*$i)):3}"
        done
        (( lines++ ))
        if (( $lines == 4 ));then
            for item in "${tab[@]}"
            do
                output+="$(decode "$item")"
            done
        output=${output:0:-1}
        output+=','
        lines=0
        unset tab
        declare -a tab
        fi
done
(( $lines == 0 )) || error "Number of input lines is not a multiple of four"
output=${output:0:-1}
echo $output
