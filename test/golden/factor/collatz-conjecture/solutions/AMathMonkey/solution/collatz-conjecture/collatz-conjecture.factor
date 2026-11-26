USING: kernel math ;
IN: collatz-conjecture

: steps ( n -- steps )
    [ 0 <= ] [ "Only positive integers are allowed" throw ] 1when
    0 swap
    [ [ 1 > ] 1check ] [ 
      [ odd? ] [ 3 * 1 + ] [ 2/ ] 1if 
      [ 1 + ] dip 
    ] while 
    drop ;
