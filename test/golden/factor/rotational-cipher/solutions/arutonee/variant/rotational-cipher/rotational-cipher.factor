USING: ascii combinators kernel math sequences strings ;
IN: rotational-cipher

: under-char ( c quot under -- c' )
    [ -rot ] keep swapd - swap call + ; inline

: rot-char ( c key -- cipher )
    { { [ over LETTER? ] [ '[ _ + 26 mod ] CHAR: A under-char ] }
      { [ over letter? ] [ '[ _ - 26 mod ] CHAR: a under-char ] }
                         [ drop ] } cond ;

: rotate ( text key -- cipher )
    '[ _ rot-char ] map ;
