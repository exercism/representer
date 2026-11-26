package BeerSong;
use strict;
use warnings;
use Exporter 'import';
our @EXPORT_OK = qw(sing);

sub sing {
    my ($input) = @_;
    my $takeDown = $input->{verses};
    my $bottles = $input->{bottles};
    my $total = $bottles == 0 || $takeDown > $bottles ? 99 : $bottles;
    return get ($takeDown, $bottles, $total);
}

sub get {
    my ($takeDown, $left, $bottles) = @_;

    return '' if $takeDown == 0;

    return qq/No more bottles of beer on the wall, no more bottles of beer.
Go to the store and buy some more, $bottles bottles of beer on the wall.
/ if $left == 0;

    my $next = ($left - 1) . ' bottle' . ($left > 2 ? 's' : '');
    return ($left == 1
        ? qq/1 bottle of beer on the wall, 1 bottle of beer.
Take it down and pass it around, no more bottles of beer on the wall.

/ 
        : qq/$left bottles of beer on the wall, $left bottles of beer.
Take one down and pass it around, $next of beer on the wall.

/) . get($takeDown - 1, $left - 1, $bottles);
}

print sing({verses => 5, bottles => 0});

