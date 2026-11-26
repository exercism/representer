package Say;

use v5.40;

use Exporter qw<import>;
our @EXPORT_OK = qw<say_number>;

use constant {
    LT_10 => [qw( _ one two three four five six seven eight nine )],
    LT_20 => [
        qw( ten eleven twelve thirteen fourteen fifteen sixteen seventeen eighteen nineteen )
    ],
    LT_100 => [qw( _ _ twenty thirty forty fifty sixty seventy eighty ninety )],

};

sub say_number ($number) {
    return !$number ? "zero" : convert_to_string($number);
}

sub convert_to_string ($num) {
    die "input out of range" if $num < 0;
    if ( $num < 10 ) {
        return LT_10->[$num];
    }
    if ( $num < 20 ) {
        return LT_20->[ $num - 10 ];
    }
    if ( $num < 100 ) {
        my ( $div, $rem ) = div_rem( $num, 10 );
        my $res = LT_100->[$div];
        $res .= '-' . LT_10->[$rem] if $rem;
        return $res;
    }
    if ( $num < 1_000 ) {
        return get_result( $num, 100, "hundred" );
    }
    if ( $num < 1_000_000 ) {
        return get_result( $num, 1000, "thousand" );
    }
    if ( $num < 1_000_000_000 ) {
        return get_result( $num, 1000000, "million" );
    }
    if ( $num <= 1_000_000_000_000 ) {
        return get_result( $num, 1000000000, "billion" );
    }
    die "input out of range";
}

sub get_result ( $num, $mod, $place ) {
    my ( $div, $rem ) = div_rem( $num, $mod );
    my $prefix = $div > 10 ? convert_to_string($div) : LT_10->[$div];
    my $res    = sprintf "%s %s", $prefix, $place;
    $res .= sprintf " %s", convert_to_string($rem) if $rem;
    return $res;
}

sub div_rem ( $num, $mod ) { return ( $num / $mod, $num % $mod ); }

1;
