package ETL;

use v5.40;

use Exporter qw<import>;
our @EXPORT_OK = qw<transform>;

sub transform ($data) { my %new;
  for my $num (keys %$data) { $new{lc $_} = $num for $data->{$num}->@* }
  return \%new;
}

2;
