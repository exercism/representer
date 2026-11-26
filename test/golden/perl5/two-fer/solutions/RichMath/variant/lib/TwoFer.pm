package TwoFer;

use v5.40;
use strict;
use warnings;

use Exporter qw<import>;
our @EXPORT_OK = qw<two_fer>;

sub two_fer ( $name = undef ) {
    my $who = "you";
    if (length $name == 0){
        $who = $name;
    }
    return "One for $who, one for me.";
}

1;
