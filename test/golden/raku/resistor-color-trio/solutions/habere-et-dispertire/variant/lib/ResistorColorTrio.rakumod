constant %METRIC-PREFIX = << '' kilo mega giga >>.pairs;
constant %COLOR-OHM     = < black brown red orange yellow green blue violet grey white >.antipairs;

sub units ( $Ω ) {

    sprintf '%s %sohms', $Ω.substr( 0, * + $_ × 3 ), %METRIC-PREFIX{ $_ }
    given gather for $Ω.flip.comb { .take when 0 orelse last }.elems div 3

}

sub create-label ( *@colors ) is export {

    units Int.new: join '', .head( 2 ).Slip, 0 x .tail
    given %COLOR-OHM{ @colors[ ^3 ] }

}