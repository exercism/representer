USING: kernel math math.functions ;
IN: square-root

: square-root ( n -- root )
    1 [ 2dup 2 ^ = ] [ 1 + ] until nip ;
