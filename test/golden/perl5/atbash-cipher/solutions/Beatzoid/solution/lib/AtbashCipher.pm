package AtbashCipher;

use v5.38;

use Exporter qw<import>;
our @EXPORT_OK = qw<encode_atbash decode_atbash>;

sub comb ( $string, $span ) {
    join ' ', $string =~ /.{1,$span}/g
}

sub encode_atbash ( $phrase, $encode = lc $phrase ) {
    $encode =~ tr/a-z/zyxwvutsrqponmlkjihgfedcba/;
    $encode = join '', split / |,|\./, $encode;

    comb $encode, 5
}

sub decode_atbash ( $phrase, $decode = lc $phrase ) {
    $decode =~ tr/zyxwvutsrqponmlkjihgfedcba/a-z/;
    join '', split ' ', $decode
}