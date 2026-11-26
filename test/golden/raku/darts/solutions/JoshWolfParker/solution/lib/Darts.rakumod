unit module Darts;

sub score-dart ( :$x, :$y ) is export {
    my $distanceSquared = $x * $x + $y * $y;
    my $result = 10;
    $result = 5 if $distanceSquared > 1;
    $result = 1 if $distanceSquared > 25;
    $result = 0 if $distanceSquared > 100;

    return $result;
}
