package BeerSong;
use strict;
use warnings;
use Exporter 'import';
our @EXPORT_OK = qw(sing);

sub sing {
  my ($input) = @_; 
  
  my $startBottles = $input->{bottles};
  my $takeDown = $input->{verses};
  my $verses = $input->{verses};

  my $text = "";

  for (my $i = $startBottles; $takeDown >= 1 and $i > 0; $i--, $takeDown--) {
    my $bottles = "$i ${ $i > 1 ? \'bottles' : \'bottle' }";
    my $left = $i - 1;
    my $left_bottles = $left == 0 ? "no more bottles" : "$left ${ $left > 1 ? \'bottles' : \'bottle' }";
    $text .= "$bottles of beer on the wall, $bottles of beer.\nTake ${ $left == 0 ? \'it' : \'one'} down and pass it around, $left_bottles of beer on the wall.\n\n";
  }

  $text .= "No more bottles of beer on the wall, no more bottles of beer.\nGo to the store and buy some more, 99 bottles of beer on the wall." if $verses > $startBottles;

  return $text;
}

1;
