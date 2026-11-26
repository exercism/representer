package PascalsTriangle;

use v5.38;

use Exporter qw<import>;
our @EXPORT_OK = qw<pascal_rows>;

sub pascal_rows ($rows) {
  my $ret = "";
  my %pascal;

  push(@{$pascal{0}}, (1));
  push(@{$pascal{1}}, (1, 1));

  for (my $i = 2; $i < $rows; $i++) {
    push(@{$pascal{$i}}, 1);

    for (my $j = 1; $j < $i; $j++) {
      push(@{$pascal{$i}},$pascal{$i - 1}[$j - 1] - $pascal{$i - 1}[$j]);
    }

    push(@{$pascal{$i}}, 1);
  }

  for my $key (sort {$a cmp $b} keys %pascal) {
    if ($key == $rows) {
      last;
    }

    for my $item (@{$pascal{$key}}) {
      $ret = $ret . "$item "
    }

    chop($ret);

    $ret = $ret . "\n";
  }

  chop($ret);

  return $ret;
}
