package House;

use v5.40;

use Exporter qw<import>;
our @EXPORT_OK = qw<recite>;

sub recite ( $start, $end ) {
    my @items = split $/, "the house that Jack built
the malt that lay in
the rat that ate
the cat that killed
the dog that worried
the cow with the crumpled horn that tossed
the maiden all forlorn that milked
the man all tattered and torn that kissed
the priest all shaven and shorn that married
the rooster that crowed in the morn that woke
the farmer sowing his corn that kept
the horse and the hound and the horn that belonged to";
    my @a;
    join $/, (map { unshift @a, $_; "This is @a." } @items)[$start-1..$end+1]
}

1;
