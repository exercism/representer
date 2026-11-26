package BottleSong;

use v5.40;

use Exporter qw(import);
our @EXPORT_OK = qw(sing);

my @numbers = qw(no one two three four five six seven eight nine ten);

sub sing ( $bottles, $verses ) {
    return join "\n", map { verse($bottles - $_) } 0..$verses - 1;
}

sub verse($number) {
    my $cap = ucfirst $numbers[$number];
    my $cap_sp = $number == 1 ? 'bottle' : 'bottles';
    
    my $prev = $numbers[$number - 1];
    my $prev_sp = $prev eq 'one' ? 'bottle' : 'bottles';
    
    my $lines =<<~"END_LINES";
    $cap green $cap_sp hanging on the wall,
    $cap green $cap_sp hanging on the wall,
    And if one green bottle should accidentally fall,
    There'll be $prev green $prev_sp hanging on the wall.
    END_LINES

    return $lines;
}

1;
