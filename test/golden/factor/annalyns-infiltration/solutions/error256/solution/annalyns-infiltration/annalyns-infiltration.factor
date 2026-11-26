USING: kernel math.order ;
IN: annalyns-infiltration

: can-do-fast-attack ( knight-awake -- ? )
    not ;

: can-spy ( knight-awake archer-awake prisoner-awake -- ? )
    or or ;

: can-signal-prisoner ( archer-awake prisoner-awake -- ? )
    [ not ] dip and ;

: can-free-prisoner ( archer-awake dog-present prisoner-awake knight-awake -- ? )
    rot [ 2drop not ] [ rot or not and ] if ;
