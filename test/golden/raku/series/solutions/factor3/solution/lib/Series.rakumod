unit module Series;

sub series ($text, $len where 1..$text.chars) is export {
    $text.comb.rotor($len => 1-$len)>>.join
}