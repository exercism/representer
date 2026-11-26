USING: kernel ;
IN: annalyns-infiltration

: can-do-fast-attack ( knight-awake -- ? )
    not ;

: can-spy ( knight-awake archer-awake prisoner-awake -- ? )
    or or ;

: can-signal-prisoner ( archer-awake prisoner-awake -- ? )
    swap not and ;

:: can-free-prisoner ( archer-awake dog-present prisoner-awake knight-awake -- ? )
    dog-present archer-awake not and ! cond 1
    prisoner-awake knight-awake not ! ( cond1 prisoner-awake knight-asleep )
    archer-awake  ! ( cond1 prisoner-awake knight-asleep archer-awake )
    not and and   ! ! ( cond1 (prisoner-awake AND (knight-asleep AND archer-asleep) ) )
    or ;
