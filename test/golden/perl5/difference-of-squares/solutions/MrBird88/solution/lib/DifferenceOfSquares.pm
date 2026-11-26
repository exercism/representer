package DifferenceOfSquares;

use v5.38;

use List::Util 'reduce';
use Exporter qw<import>;
our @EXPORT_OK = qw<square_of_sum sum_of_squares difference_of_squares>;

sub square_of_sum ($number) {
    return sum_interval($number)**2;
}

sub sum_of_squares ($number) {
    return reduce { $a < $b ? $a**2 + $b**2 : $a + $b**2 } 1 .. $number;
}

sub difference_of_squares ($number) {
    return square_of_sum($number) - sum_of_squares($number);
}

sub sum_interval ($n) {
    return ( $n + 1 ) * $n / 2;
}
