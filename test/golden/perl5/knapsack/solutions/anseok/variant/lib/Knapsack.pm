package Knapsack;

use v5.40;

use Exporter qw<import>;
our @EXPORT_OK = qw<maximum_value>;

sub compare {
  my $n = $b->{'weight'} <=> $a->{'weight'};
  return $n ? $n : $b->{'value'} <=> $a->{'value'} }

sub search;
sub search($items, $weight, $i) {
  my $n = @$items;
  for ( ; $i < $n && $items->[$i]->{'weight'} > $weight; ++$i) { }
  $i > $n && return 0; my $x = $items->[$i]; ++$i;
  my $l = $x->{'value'} + search $items, $weight - $x->{'weight'}, $i;
  my $r = search $items, $weight, $i; return $r > $l ? $r : $l }

sub maximum_value($items, $weight) {
  return search [sort compare @$items], $weight, 0 }

1;
