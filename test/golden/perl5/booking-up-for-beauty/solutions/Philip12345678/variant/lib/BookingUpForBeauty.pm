package BookingUpForBeauty;

use v5.40;

# Suggested datetime modules you can use:
use Time::Piece;
#use DateTime::Tiny;

# Recommended, commented out for portability.
#use Const::Fast;

use Exporter ('import');
our @EXPORT_OK = (
	'appointment_has_passed',
	'is_afternoon_appointment',
	'describe_appointment'
);

my $STRPTIME_FORMAT = '%Y-%m-%d' . 'T' . '%H:%M:%S';
#const $STRPTIME_FORMAT => $STRPTIME_FORMAT;

# Private subroutines conventionally start with an underscore.
# It isn't necessary, but provided for convenience.
sub _parse_datetime ($date_string) {
	return Time::Piece->strptime($date_string, $STRPTIME_FORMAT);
}

sub appointment_has_passed ($date_string) {
    my $time = _parse_datetime($date_string);
		my $now = localtime;
		return $now >= $time;
}

sub is_afternoon_appointment ($date_string) {
    my $time = _parse_datetime($date_string);
		return 12 <= $time->hour && $time->hour < 18
}

sub describe_appointment ($date_string) {
    my $time = _parse_datetime($date_string);
		return $time->strftime("You have an appointment on %m/%d/%Y %-l:%M %p");
}


1;
