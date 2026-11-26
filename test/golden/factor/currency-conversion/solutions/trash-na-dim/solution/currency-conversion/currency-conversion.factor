USING: kernel math math.functions math.order prettyprint ;
IN: currency-conversion

: exchange-money ( budget exchange-rate -- exchanged )
    /f ;

: get-change ( budget exchanging-value -- change )
    - ;

: value-of-bills ( denomination number-of-bills -- value )
    * ;

: number-of-bills ( amount denomination -- bills )
    /i ;

: leftover-of-bills ( amount denomination -- leftover )
    mod ;

: exchangeable-value ( denomination budget spread exchange-rate -- value )
    swap 100 /f dupd * + ! denomination budget adjusted-rate
    exchange-money ! denomination new-money
    dupd swap / floor * >integer
    ;

: safe-change ( budget exchanging-value -- change )
    get-change 0 max
    ;

: cap-spend ( budget price -- spend )
    min ;
