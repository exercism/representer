USING: kernel
    math
    sequences arrays
    combinators ;
IN: valentines-day

SYMBOLS: yes no maybe
    korean turkish
    crime horror romance thriller
    board-game chill movie restaurant walk ;

: rate-restaurant ( cuisine -- approval )
    {
        { korean [ yes ] }
        [ drop maybe ]
    } case ;

: rate-movie ( genre -- approval )
    {
        { romance [ yes ] }
        [ drop no ]
    } case ;

: rate-walk ( km -- approval )
    {
        { [ dup 11 > ] [ drop yes ] }
        { [ dup 6 > ] [ drop maybe ] }
        [ drop no ]
    } cond ;

: rate-activity ( activity -- approval )
    first2 swap
    {
        { movie [ rate-movie ] }
        { restaurant [ rate-restaurant ] }
        { walk [ rate-walk ] }
        [ 2drop no ]
    } case ;

: approval-counts ( activities -- counts )
    [ 0 0 0 ] dip
    [
      rate-activity {
        { yes [ [ 1 + ] 2dip ] }
        { maybe [ [ 1 + ] dip  ] }
        { no [ 1 + ] }
      } case
    ] each 
    3array ;