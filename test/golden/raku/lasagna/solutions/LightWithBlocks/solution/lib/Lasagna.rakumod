unit module Lasagna;

constant $EXPECTED-MINUTES-IN-OVEN = 40;

sub remaining-minutes-in-oven ($actual-minutes-in-oven) is export {
    return $EXPECTED-MINUTES-IN-OVEN - $actual-minutes-in-oven
}

sub preparation-time-in-minutes ($number-of-layers) is export {
    return 2 * $number-of-layers
}

sub total-time-in-minutes ( $number-of-layers, $actual-minutes-in-oven ) is export {
    return preparation-time-in-minutes($number-of-layers) + $actual-minutes-in-oven
}

sub oven-alarm () is export {
    return 'Ding!'
}
