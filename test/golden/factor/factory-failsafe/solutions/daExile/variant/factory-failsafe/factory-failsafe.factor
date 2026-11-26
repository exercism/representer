USING: kernel math continuations sequences ;
IN: factory-failsafe

ERROR: machine-error ;

: check-humidity ( h -- ) 70 > [ "humidity too high" throw ] when ;

: check-temperature ( t -- ) 500 >= [ "temperature too high" throw ] when ;

: monitor ( h t -- ) 
    [ [ check-humidity ] [ check-temperature ] bi* ]
    [ drop machine-error throw ] recover ;

: monitor-batch ( readings -- count )
    0 swap [ [ first2 monitor ] [ 2drop 1 + ] recover ] each ;