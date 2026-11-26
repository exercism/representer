package Sieve;

use v5.40;

use Exporter qw<import>;
our @EXPORT_OK = qw<find_primes>;

sub find_primes($limit) {
  my %marked;
  for my $i (2..$limit) {
    $marked{$i} = 0 unless (defined($marked{$i}));
    $marked{$_} = 1 for map { $_ * $i } (2 .. $limit / $i);
  }

  return [ grep { $marked{$_} == 0 } 2 .. $limit ];
}


1;
