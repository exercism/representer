unit module Proverb;

sub recite (@nouns) is export {
    return "" unless @nouns;

    my @lines = @nouns.rotor(2 => -1).map(-> ($a, $b) {
        "For want of a $a the $b was lost."
    });

    @lines.push("And all for the want of a {@nouns[0]}.");

    @lines.join("\n");
}