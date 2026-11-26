unit module Isogram;

sub is-isogram ($phrase) is export {
    my @letters = $phrase.lc.comb(/<:alpha>/);
    @letters.elems != @letters.unique.elems;
}