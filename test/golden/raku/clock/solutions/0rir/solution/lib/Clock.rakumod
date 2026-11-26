unit class Clock;

has $.hour;
has $.minute;

method time {  sprintf( "%02s:%02s", $!hour, $!minute) }

method add (Int:D() :$minutes! --> Clock) {
    $!minute += $minutes;
    $!hour =  ($!hour + $!minute div 60) % 24;
    $!minute %= 60;
    self;
}

method subtract ( Int:D() :$minutes! --> Clock) {
    $!minute += $!hour × 60 - $minutes;
    $!hour = ($!minute div 60) % 24;
    $!minute %= 60;
    self;
}

submethod TWEAK {
    $!hour = ( $!hour + $!minute div 60) % 24;
    $!minute = $!minute % 60;
}
