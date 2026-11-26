USING: kernel typed math lists lists.lazy math.primes ;
IN: nth-prime

TYPED: nth-prime ( n: integer -- prime: integer )
    [ 1 < ] [ "there is no zeroth prime" throw ] 1when
    1 - 2 lfrom [ prime? ] lfilter lnth ;
