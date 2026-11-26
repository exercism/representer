package Sieve;

use v5.40;

use Exporter qw<import>;
our @EXPORT_OK = qw<find_primes>;

sub find_primes ($limit) {
    my @bad;
    my @l = (2 .. $limit);
    my @p;
    for my $i (2 .. $limit) {
        my $flag = 0;
        for my $b (@bad) {
            if ($b == $i) {
                $flag = 1;
            }
        }
        push @p, $i unless ($flag);
        push @bad, map { $i * $_ } @l;
    }
    return \@p;
}

1;
