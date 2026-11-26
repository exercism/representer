USING: arrays combinators.short-circuit.smart kernel sequences ;
IN: annalyns-infiltration

: can-do-fast-attack ( knight-awake -- ? )
    not ;

: can-spy ( knight-awake archer-awake prisoner-awake -- ? )
    or or ;

: can-signal-prisoner ( archer-awake prisoner-awake -- ? )
    swap not and ;

: can-free-prisoner ( archer-awake dog-present prisoner-awake knight-awake -- ? )
    {
        [ 2drop can-signal-prisoner ]
        [ 4array { { f f t f } { f t t f } } member? ]
    } || ;
