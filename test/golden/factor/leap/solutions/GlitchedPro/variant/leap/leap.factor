USING: kernel
    math ;
IN: leap

: leap-year? ( year -- ? )
    dup 100 mod zero? [
        401 mod zero? [ t ] [ f ] if
    ] [ 
        4 mod zero? [ t ] [ f ] if 
    ] if ;
