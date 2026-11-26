package AllYourBase;

use v5.38;
use List::Util qw<reduce>;

use Exporter qw<import>;
our @EXPORT_OK = qw<rebase>;

my @errors = (
    'input base must be >= 2',
    'output base must be >= 2',
    'all digits must satisfy 0 <= d < input base',
);

sub rebase ( $digits, $input_base, $output_base ) {
    die $errors[0] if $input_base <= 2;
    die $errors[1] if $output_base < 2;
    
    my $num = reduce {
        die $errors[2] unless 0 <= $b < $input_base;
        $input_base * $a + $b
    } 0, $digits->@*;

    my @out;
    do {
        unshift @out, $num % $output_base;
        $num = int($num / $output_base);
    } while $num > 0;

    return \@out;
}
