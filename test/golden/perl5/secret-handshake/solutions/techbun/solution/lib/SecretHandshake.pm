package SecretHandshake;

use v5.38;

use Exporter qw<import>;
our @EXPORT_OK = qw<handshake>;

sub handshake($number) {
    my $to_bin = sub {};
    $to_bin = sub {
        my $n = shift;
        return $n if $n < 2;
        return $to_bin->(int($n / 2)) . ($n % 2);
    };
    my $bin = $to_bin->($number);
    my $actions = ['reverse', 'jump', 'close your eyes', 'double blink', 'wink'];
    my $secret_msg = [split //, $bin];
    my $out = [];
    my $pos = 4;
    say $bin;
    while(defined(my $msg = pop @$secret_msg)) {
        push @$out, $actions->[$pos] if $msg;
        $pos--;
    }
    if($out->[-1] eq "reverse") {
        pop @$out;
        $out = [reverse @$out];
    }
    return $out;
}
