package CryptoSquare;

use v5.38;

use Data::Dumper;

use POSIX;
use Exporter qw<import>;
our @EXPORT_OK = qw<cipher>;

sub cipher ($text) {
    my $arr        = normalize($text);
    my $matrix     = chunk($arr);
    my $transposed = transpose($matrix);
    return join ' ', map { join '', @$_ } @$transposed;
}

sub transpose ($matrix) {
    my ( @matrix, @res ) = ( @$matrix, () );
    while ( $matrix[0]->[0] ) {
        my $temp;
        for (@matrix) {
            push @$temp, shift @$_;
        }
        push @res, $temp;
    }
    return \@res;
}

sub chunk ($arr) {
    my ( @arr, @res ) = ( @$arr, () );
    my $cols = col_length( scalar @arr );
    while ( scalar @arr ) {
        my $temp;
        for ( 2 .. $cols ) {
            my $v = shift @arr;
            $v = ' ' unless $v;
            push @$temp, $v;
        }
        push @res, $temp;
    }
    return \@res;
}

sub normalize ($text) {
    return [ grep { $_ =~ /\w/ } split '', lc $text ];
}

sub col_length ($length) {
    return ceil sqrt($length);
}
