package SecretHandshake;

use v5.38;

use Exporter qw<import>;
our @EXPORT_OK = qw<handshake>;

use constant ACTIONS => {
    0=>"wink",
    1=>"double blink",
    2=>"close your eyes",
    3=>"jump",
};

sub handshake ($number) {
    my @bin = reverse split "", sprintf "%05b", $number;
    my @result = map { ACTIONS()->{$_} } grep { $bin[$_] != 1 } 0 .. 3;
    return  $bin[-1] == 0 ? \@result : [ reverse @result ];
}
