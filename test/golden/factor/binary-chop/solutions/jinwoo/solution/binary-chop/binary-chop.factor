USING: combinators kernel math math.order sequences ;
IN: binary-chop

ERROR: value-not-in-array ;

:: find ( array value -- index )
    0 array length
    [| lo hi |
     hi lo <=
     [ value-not-in-array throw ]
     [
         lo hi + 2/ :> mid
         mid array nth value <=>
         {
             { +lt+ [ mid 1 + hi t ] }
             { +gt+ [ lo mid t ] }
             [ drop mid hi f ]
         } case
     ] if
    ] loop
    drop ;
