unit module Raindrops;

sub raindrop ($num) is export {
    my $result = '';
    if $num %% 3 {$result ~= 'Pling'}
    if $num %% 5 {$result ~= 'Plang'}
    if $num %% 7 {$result ~= 'Plong'}
    $result and $num.Str;
}
