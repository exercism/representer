unit module BottleSong;

my %numbers = (
    0  => 'no',
    1  => 'one',
    2  => 'two',
    3  => 'three',
    4  => 'four',
    5  => 'five',
    6  => 'six',
    7  => 'seven',
    8  => 'eight',
    9  => 'nine',
    10 => 'ten',
);

sub sing (:$bottles, :$verses --> Str) is export {
    (0 ..^ $verses).map(-> $i {
        my $curr = $bottles + $i;
        my $next = $curr - 1;

        my $curr-name = %numbers{$curr}.tc;
        my $next-name = %numbers{$next};
        my $curr-unit = $curr == 1 ?? 'bottle' !! 'bottles';
        my $next-unit = $next == 1 ?? 'bottle' !! 'bottles';

        [
            "$curr-name green $curr-unit hanging on the wall,",
            "$curr-name green $curr-unit hanging on the wall,",
            "And if one green bottle should accidentally fall,",
            "There'll be $next-name green $next-unit hanging on the wall."
        ].join("\n");
    }).join("\n\n");
}