#!/usr/bin/perl

package Trinary;

use warnings;
use strict;

sub new {
  my ($class, $n) = @_;
  my $self = \$n;
  bless $self, $class;
  return $self;
}

sub to_decimal {

  my ($self) = @_;

  my $r = 0;
  my $c = 0;

  if ($$self =~ /[^012]/) {
    return 0;
  } else {

    for (reverse split(//, $$self)) {
      $r += $_ * 3 ** $c;
      $c++;
    }

    return $r;
  }

}


1;