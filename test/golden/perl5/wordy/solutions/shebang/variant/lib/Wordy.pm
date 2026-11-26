package Wordy;

use v5.40;

use Exporter qw<import>;
our @EXPORT_OK = qw<answer>;

sub answer ($question) {
  my @exp = grep defined, split /\s+/,
    trim( $question =~ s/^What is\s*|\?$//gr =~ s/plus/+/gr
      =~ s/minus/-/gr =~ s/multiplied by/*/gr =~ s/divided by/\//gr );
  die q{unknown operation} if grep /[^-+*\d\/]/, @exp;
  die q{syntax error} if @exp % 2 == 0;
  my $n = shift @exp; $n = calc($n, shift(@exp), shift @exp) while @exp;
  return $n;
}

sub calc ($n0, $op, $n1) {
  die q{syntax error} if ($n0 . $n1) !~ /^(?:-?\d+){2}$/ and $op !~ /^[-+*\/]$/;
  return eval qq{$n0 $op $n1};
}

1;
