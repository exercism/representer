unit module House;

constant @components = (
    ('house that Jack built', ''),
    ('malt', 'lay in'),
    ('rat', 'ate'),
    ('cat', 'killed'),
    ('dog', 'worried'),
    ('cow with the crumpled horn', 'tossed'),
    ('maiden all forlorn', 'milked'),
    ('man all tattered and torn', 'kissed'),
    ('priest all shaven and shorn', 'married'),
    ('rooster that crowed in the morn', 'woke'),
    ('farmer sowing his corn', 'kept'),
    ('horse and the hound and the horn', 'belonged to'),
);

sub verse ($n) {
    my @parts = "This is the {@components[$n - 1][0]}";
    for (1 .. $n - 1).reverse -> $i {
        @parts.push("that {@components[$i][1]} the {@components[$i + 1][0]}");
    }
    @parts.join(' ') ~ '.';
}

sub house ( $start, $end ) is export {
    ($start .. $end).map(&verse).join("\n");
}