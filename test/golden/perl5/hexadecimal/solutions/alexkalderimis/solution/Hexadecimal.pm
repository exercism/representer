package Hexadecimal;

use v5.14.0;
use warnings;

use List::Util qw/reduce/;

my %DIGITS;
@DIGITS{0 .. 9, 'a' .. 'f'} = (0 .. 15);

sub new {
    my ($class, $value) = @_;
    bless \$value, $class;
}

sub to_decimal {
    my $hex = shift;
    my $ret = reduce {
        (defined $a && defined $DIGITS{$b})
            ? $a * 16 + $DIGITS{$b} : undef
        } 0, split '', $$hex;
    $ret // 0;
}

1;