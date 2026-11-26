package Allergies;

use strict;
use warnings;
use feature qw<say>;
use Math::Complex;
use POSIX;

use Exporter qw<import>;
our @EXPORT_OK = qw<allergic_to list_allergies>;

sub allergic_to {
    my ( $item, $score ) = @_;
    my @list = list_allergies( $score );
print "XXXXXX\n";
foreach (@list) {
  print "$_\n";
}
    if (grep($item, @list)) {
      return "TRUE";
    } else {
      return "0";
    }
}

sub list_allergies {
    my ($score) = @_;
    my @list;
    my $item;
    my %allergies = ( 0 => 'eggs',
                      1 => 'peanuts',
                      2 => 'shellfish',
                      3 => 'strawberries',
                      4 => 'tomatoes',
                      5 => 'chocolate',
                      6 => 'pollen',
                      7 => 'cats',);
my $temp;    
while ($score > 0) {
      $temp = floor(log($score)/log(2));
      $score -= ($temp ** 2);
      if ($temp >7 ) {
next;
      } elsif ($temp <= 0 ) {
return @list;
      } else {
push (@list, $allergies{$temp});
      }
}
return @list;
}

