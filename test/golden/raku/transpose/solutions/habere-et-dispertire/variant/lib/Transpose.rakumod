sub transpose ( $text, @matrix = [] ) is export {

    for pairs lines $text
    -> $line {
        @matrix[ .key ; $line.key ] = .value for $line.value.comb.pairs
    }

    @matrix.deepmap( { $_ orelse ' ' } )
           .grep( *.join )
           .join: "\n"

}