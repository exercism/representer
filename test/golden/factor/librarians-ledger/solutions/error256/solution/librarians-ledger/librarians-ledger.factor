USING: kernel math math.order math.statistics sequences ;
IN: librarians-ledger

: protected-balance ( opening requests -- balance )
    [ + 0 max ] each ;

: running-balance ( transactions -- balances )
    cum-sum ;

: least-balance-so-far ( transactions -- worsts )
    running-balance cum-min ;

: halve-until ( principal target -- balances )
    '[ dup _ > ] [ 2/ dup ] produce nip ;
