USING: kernel math sequences ;
IN: backyard-birdcount

: today ( days -- count/f )
    [ f ] [ first ] if-empty ;

: increment-day-count ( days -- new-days )
    [ { 1 } ] [ clone 0 over [ 1 + ] change-nth ] if-empty ;

: has-day-without-birds? ( days -- ? )
    [ f ] [
        dup first zero? [ drop t ] [ 1 tail has-day-without-birds? ] if
    ] if-empty ;

: total ( days -- sum )
    [ 0 ] [ [ first ] [ 1 tail total ] bi + ] if-empty ;

: busy-days ( days -- count )
    [ 0 ] [
        [ first 5 >= [ 1 ] [ 0 ] if ] [ 1 tail busy-days ] bi +
    ] if-empty ;
