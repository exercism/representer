USING: kernel sequences math unicode pair-rocket combinators ;
IN: rotational-cipher

: rotate ( text key -- cipher )
    swap [| k c |
        {
            [ c letter? ] => [ c 97 - k + 26 rem 97 + ]
            [ c LETTER? ] => [ c 65 - k + 26 rem 65 + ]
            [ c ]
        } cond
    ] with map ;
