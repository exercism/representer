package Gigasecond;

use v5.41;

use Exporter qw<import>;
our @EXPORT_OK = qw<add_gigasecond>;

use Time::Piece;

sub add_gigasecond ($time) {
    my $tp = Time::Piece->strptime($time, '%Y-%m-%dT%T');
    $tp += 1_000_000_000;
    return $tp->datetime;
}

1;
