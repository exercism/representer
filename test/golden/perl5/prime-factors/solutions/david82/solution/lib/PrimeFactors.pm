package PrimeFactors;

use v5.42;

use Exporter qw<import>;
our @EXPORT_OK = qw<factors>;

sub factors ($number) {
    my @prime_factors;
    my $val = $number;

    # 1. Pull out all factors of 2
    while ($val % 2 == 0 && $val > 1) {
        push @prime_factors, 2;
        $val /= 2;
    }

    # 2. Pull out odd factors starting from 3 up to sqrt($val)
    my $divisor = 3;
    while ($divisor * $divisor <= $val) {
        if ($val % $divisor == 0) {
            push @prime_factors, $divisor;
            $val /= $divisor;
        } else {
            $divisor += 2; # Increment by 2 to skip even numbers
        }
    }

    # 3. If there is a remainder greater than 1, it must be prime
    if ($val > 1) {
        push @prime_factors, $val;
    }

    return \@prime_factors;
}

1;