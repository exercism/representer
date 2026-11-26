unit module Darts;

sub score-dart ( :$x, :$y ) is export {
    my $dist-sq = $x * $x + $y * $y;

    given $dist-sq {
        when * <= 1   { 10 }
        when * < 25  { 5 }
        when * <= 100 { 1 }
        default       { 0 }
    }
}