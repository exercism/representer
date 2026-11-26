package Meetup;

use v5.40;

use Exporter qw<import>;
our @EXPORT_OK = qw<meetup>;

use Time::Piece;

sub meetup ($desc) {
  my ($thday, $wday, $month, $year) = split / (?:of )?/, $desc;
  my %thday = ( q{First} => 1, q{Second} => 8, q{Teenth} => 13, q{Third} => 15, q{Fourth} => 22, q{Last} => 1 );
  my $t = Time::Piece->strptime(qq{$thday{$thday} $month $year}, q{%d %B %Y});
  $t = $t->add_months(1) - 60 * 60 * 24 * 7 if $thday eq q{Last};
  $t += 60 * 60 * 24 while $t->fullday ne $wday;
  return $t->strftime(q{%F});
}

1;
