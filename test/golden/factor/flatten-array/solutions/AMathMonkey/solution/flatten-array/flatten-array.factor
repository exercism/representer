USING: kernel sequences combinators ;
IN: flatten-array

: flatten ( array -- flat )
    { } swap [ 
      { 
        { [ dup sequence? ] [ flatten append ] }
        { [ dup ] [ suffix ] }
        [ drop ]
      } cond 
    ] each ;
