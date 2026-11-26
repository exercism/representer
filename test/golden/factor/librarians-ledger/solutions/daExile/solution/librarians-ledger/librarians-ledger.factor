USING: kernel math math.order math.statistics sequences ;
IN: librarians-ledger

ALIAS: running-balance cum-sum

: protected-balance ( opening requests -- balance ) swap [ + 0 max ] reduce ;

: least-balance-so-far ( transactions -- worsts ) running-balance cum-min ;

: halve-until ( principal target -- balances ) [ 2dup > ] [ over 2 /i ] produce 2nip ;