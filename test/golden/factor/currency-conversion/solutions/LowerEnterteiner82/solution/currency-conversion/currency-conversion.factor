USING: kernel ;
USING: math ;
USING: math.functions ;
USING: math.order ;
IN: currency-conversion

: exchange-money ( budget exchange-rate -- exchanged ) / ;

: get-change ( budget exchanging-value -- change ) - ;

: value-of-bills ( denomination number-of-bills -- value ) * ;

: number-of-bills ( amount denomination -- bills ) /i ;

: leftover-of-bills ( amount denomination -- leftover ) mod ;

: exchangeable-value ( denomination budget spread exchange-rate -- value )
  dup rot 100 / * + exchange-money over / floor >integer * ;

: safe-change ( budget exchanging-value -- change ) - 0 max ;

: cap-spend ( budget price -- spend ) min ;




    
