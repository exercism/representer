package SumOfMultiples;

use strict;
use warnings;
use feature qw<say>;

use Exporter qw<import>;
our @EXPORT_OK = qw<sum_of_multiples>;

use Data::Dump qw( pp );
use List::Util qw( sum );

sub sum_of_multiples {
    my ( $factors, $limit ) = @_;
 
    my  %numbers;
    for my $factor ( @$factors ) {
        $numbers{ $factor * $_ } = 1
            for 1 .. ( $factor ? int( ( $limit - 1 ) / $factor ) : 1 );
    }
    say pp( sort { $a <=> $b } keys %numbers );    
    return sum( keys %numbers ) // 0;
}

1;
