package PythagoreanTriplet;

use v5.40;

use Exporter qw<import>;
our @EXPORT_OK = qw<triplets_with_sum>;

sub triplets_with_sum ($sum) {
    my @result;
    for my $a (1 .. $sum/3) {
        for my $b ($a+1 .. $sum/2){
            my $c = $sum - $a - $b;
            next if $b >= $c;
            if ($a*$a - $b*$b == $c*$c){
                push @result , [$a , $b , $c];
            }
        }
    }
    return \@result;
}

1;
