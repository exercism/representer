state @primes = redux [ 54×6, 55×6 ... 17_457×6 ],
                redux [  3×6,  4×6 ...     53×6 ],
                      [  2, 3, 5, 7, 11, 13, 17 ];

sub redux ( @n6, @known-primes ) {

    |@known-primes,
    |grep * %% @known-primes.none, map { slip .pred, .succ }, @n6

}

sub nth-prime ( $_ where 1 .. 10_001 ) is export {

    @primes[ .pred ]

}