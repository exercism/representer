package AtbashCipher;

use v5.38;

use Exporter qw<import>;
our @EXPORT_OK = qw<encode_atbash decode_atbash>;

my $alpha = 'abcdefghijklmnopqrstuvwxyz';
my $alpha_reverse = reverse($alpha).'0123456789';
$alpha .= '0123456789';

sub encode_atbash ($phrase) {
  my $encoded = '';
  for my $i (0..length($phrase) - 1) {
    my $char_index = index($alpha, substr(lc($phrase), $i, 1));
    next if ($char_index == -1);
    $encoded .= substr($alpha_reverse, $char_index, 1);
    if ((length($encoded) + 1) % 6 == 0 && $i != length($phrase)) { $encoded .= ' '; }
  }
  $encoded =~ s/\s+$//;
  return $encoded;
}

sub decode_atbash ($phrase) {
    my $decoded = '';
    for my $i (0..length($phrase) - 1) {
      my $char_index = index($alpha_reverse, substr(lc($phrase), $i, 1));
      next if ($char_index == -1);
      $decoded .= substr($alpha, $char_index, 1);
    }
    return $decoded;
}
