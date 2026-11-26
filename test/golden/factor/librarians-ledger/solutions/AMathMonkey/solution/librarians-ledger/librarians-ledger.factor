USING: kernel math math.order sequences math.statistics ;
IN: librarians-ledger

: protected-balance ( opening requests -- balance )
    swap [ + 0 max ] reduce ;

: running-balance ( transactions -- balances )
    cum-sum ;

: least-balance-so-far ( transactions -- worsts )
    running-balance cum-min ;

: halve-until ( principal target -- balances )
    [ 2dup > ] [ [ 2 /i ] dip over ] produce 2nip ;
