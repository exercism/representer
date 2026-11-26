use v5.38;

sub sum_of_multiples ( $factors, $limit, $sum = 0 ) {

    for my $i ( 1 .. $limit - 1 ) {
        for my $factor ( @$factors ) {
            next if          $factor == 0;
            next unless $i % $factor == 0;
            $sum += $i and last
        }
    }

    $sum

}