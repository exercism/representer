USING: kernel math ;
IN: darts

: score ( x y -- n )
    [ sq ] bi@ +
    dup 100.0 > [ drop 0 ] [ dup 25.0 >= [ drop 1 ] [ 1.0 > [ 5 ] [ 10 ] if ] if ] if ;