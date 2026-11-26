package Lasagna;

use v5.32;
use strict;
use warnings;


our $ExpectedMinutesInOven = 40;
our $PrepTimePerLayer = 2;


sub remaining_minutes_in_oven {
    my $actual_minutes_in_oven = shift;
    $ExpectedMinutesInOven - $actual_minutes_in_oven;
}

sub preparation_time_in_minutes {
    my $number_of_layers = shift;
    return $PrepTimePerLayer * $number_of_layers;
}

sub total_time_in_minutes {
    my  ($number_of_layers, $actual_minutes_in_oven) = @_;
    return preparation_time_in_minutes($number_of_layers) + $actual_minutes_in_oven;
}

sub oven_alarm {
    return "Ding!";
}
