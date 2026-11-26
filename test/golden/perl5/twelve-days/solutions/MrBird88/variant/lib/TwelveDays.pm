package TwelveDays;

use v5.40;

use Exporter qw<import>;
our @EXPORT_OK = qw<recite>;

use constant XMAS => {
    1 => {
        day  => "first",
        gift => "and a Partridge in a Pear Tree",
    },
    2 => {
        day  => "second",
        gift => "two Turtle Doves",
    },
    3 => {
        day  => "third",
        gift => "three French Hens",
    },
    4 => {
        day  => "fourth",
        gift => "four Calling Birds",
    },
    5 => {
        day  => "fifth",
        gift => "five Gold Rings",
    },
    6 => {
        day  => "sixth",
        gift => "six Geese-a-Laying",
    },
    7 => {
        day  => "seventh",
        gift => "seven Swans-a-Swimming",
    },
    8 => {
        day  => "eighth",
        gift => "eight Maids-a-Milking",
    },
    9 => {
        day  => "ninth",
        gift => "nine Ladies Dancing",
    },
    10 => {
        day  => "tenth",
        gift => "ten Lords-a-Leaping",
    },
    11 => {
        day  => "eleventh",
        gift => "eleven Pipers Piping",
    },
    12 => {
        day  => "twelfth",
        gift => "twelve Drummers Drumming",
    },
};

sub recite ( $start, $end ) {
    return join "\n", map { verse($_) } $start .. $end;
}

sub verse ($index) {
    my $day   = XMAS->{$index}->{day};
    my $gifts = join ', ', map { XMAS->{$_}->{gift} } reverse 1 .. $index;
    $gifts =~ s/and // if $index != 1;
    return "On the $day day of Christmas my true love gave to me: $gifts.";
}

1;
