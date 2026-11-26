USING: arrays ascii combinators interpolate kernel math
namespaces qw ranges sequences ;
IN: bottle-song

CONSTANT: nums qw{
    no One Two Three Four Five
    Six Seven Eight Nine Ten
}

: verse ( n -- seq )
    {
        [ nums nth "num" set ]
        [ 1 - nums nth >lower "num-1" set ]
        [ 1 = "bottle" "bottles" ? "bottle-a" set ]
        [ 2 = "bottle" "bottles" ? "bottle-b" set ]
    } cleave
    I"${num} green ${bottle-a} hanging on the wall,"
    dup
    "And if one green bottle should accidentally fall,"
    I"There'll be ${num-1} green ${bottle-b} hanging on the wall."
    4array ;

: recite ( start take -- lines )
    dupd + [a..b) [ verse ] map { "" } join ;