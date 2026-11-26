package Series;

use v5.38;

use Exporter qw<import>;
our @EXPORT_OK = qw<slices>;

sub slices ( $series, $slice_length ) {
    our @out =();
    if (length($series) == 0) {
        die "series cannot be empty";
    }
    if ($slice_length == 0) {
        die "slice length cannot be zero";
    }
    if ($slice_length > length($series)) {
        die "slice length cannot be greater than series length";
    }
    if ($slice_length < 0) {
        die "slice length cannot be negative";
    }
    my $start = 0;
    my $end = $start + $slice_length;
    while ($end <= length($series)) {
        
        push(@out, substr($series, $start, $slice_length));
        # Increment start and end pointers
        $start++;
        $end++;
    }
    return [@out];
}
