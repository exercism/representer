unit class Clock;

has $.hour;
has $.minute;

method normalize {
    if $!minute > 59 || $!minute < 0 {
        my $tmp = $!minute;
        $!minute = $tmp % 60;
        $!hour += $tmp div 60;
    }
    if $!hour > 23 || $!hour < 0 {
        $!hour = $!hour % 24;
    }
}

method time {
    sprintf("%02d:%02d", self.hour, self.minute)
}

method add (:$minutes --> Clock) {
    $!minute += $minutes;
    self.normalize();
    return self;
}

method subtract (:$minutes --> Clock) {
    self.add(:minutes($minutes * -1));
    return self;
}

submethod TWEAK () {
    self.normalize();

    return self;
}
