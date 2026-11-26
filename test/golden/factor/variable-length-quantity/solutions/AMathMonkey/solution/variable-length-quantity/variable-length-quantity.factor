USING: kernel sequences sequences.extras math.vectors math.bitwise math assocs splitting continuations ;
IN: variable-length-quantity

<PRIVATE
: extract7 ( n -- first7 rest )
    [ 7 bits ] [ -7 shift ] bi ;
PRIVATE>

: encode ( integers -- bytes )
    [ 
        [ extract7 dup 0 > [ swap 7 set-bit ] dip ] loop>array* reverse 
        [ [ 7 clear-bit ] change-last ] keep nip 
    ] map-concat ;

: decode ( bytes -- integers )
    [ [ 7 bit? not ] find-all keys 1 v+n ] keep swap split-indices 
    unclip-last empty? [ "incomplete sequence" throw ] unless
    [ 0 [ [ 7 shift ] [ 7 bits ] bi* bitor ] reduce ] map ;
