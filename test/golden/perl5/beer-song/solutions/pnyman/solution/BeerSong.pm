package BeerSong;
use strict;
use warnings;
use Exporter qw<import>;
our @EXPORT_OK = qw<sing>;

sub verse {
    my $n = shift;
    join '',
      ucfirst sprintf(
        "%s bottle%s of beer on the wall, %1\$s bottle%2\$s of beer.\n",
        $n      ? $n : 'no more',
        $n == 1 ? '' : 's'
      ),
      $n ? sprintf(
        "Take %s down and pass it around, %s bottle%s",
        $n == 1 ? 'it' : 'one',
        --$n    ? $n   : 'no more',
        $n == 1 ? ''   : 's'
      )
      : "Go to the store and buy some more, 99 bottles",
      " of beer on the wall.\n\n";
}

sub sing {
    my ( $input, $result ) = shift;
    for ( 1 .. $input->{verses} ) {
        $result .= verse( $input->{bottles} );
        $input->{bottles}--;
    }
    $result;
}

1;
