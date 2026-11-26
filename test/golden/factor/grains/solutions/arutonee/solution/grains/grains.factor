USING: kernel literals math math.bitwise math.order ;
IN: grains

CONSTANT: fail-message "square must be between 1 and 64"

: square ( n -- grains )
    dup 1 64 between? [ fail-message throw ] unless
    1 - 2^ ;

CONSTANT: total $[ 0 bitnot 64 bits ]
