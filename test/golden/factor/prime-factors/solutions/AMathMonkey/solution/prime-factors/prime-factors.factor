USING: kernel math math.functions sequences ;
IN: prime-factors

:: factors ( n -- factors )
    n :> n!
    { } clone
    [ n 1 > ] [
      2 
      [ n over divisor? ] [ 1 + ] until 
      [ suffix ] [ n swap / n! ] bi 
    ] while ;
